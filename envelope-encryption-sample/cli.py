
# Import base64 for encoding the bytes for printing.
import base64
import json
from absl import flags, app
from base64 import b64encode, b64decode

# Import the client library.
from google.cloud import kms

from cryptography.fernet import Fernet

FLAGS = flags.FLAGS

flags.DEFINE_enum(
    "mode",
    None,
    ["generate", "encrypt", "decrypt"],
    "The operation to perform.",
)
flags.DEFINE_string(
    "wrapped_key_path", None, "Path to the wrapped used for encryption."
)
flags.DEFINE_string(
    "kek_name", None, "The Cloud KMS key name of the key encryption key."
)
flags.DEFINE_string(
    "keyring_name", None, "The Cloud KMS keyring name."
)
flags.DEFINE_string(
    "project_id", None, "The GCP Project ID."
)
flags.DEFINE_string(
    "location", None, "The GCP location name."
)
flags.DEFINE_integer(
    "num_bytes",
    32,
    "The number of bytes that Data Encryption Key should have."
)

flags.DEFINE_string("input", None, "Path to the input file.")
flags.DEFINE_string("output", None, "Path to the output file.")

# flags.DEFINE_string(
#     "gcp_credential_path", None, "Path to the GCP credentials JSON file."
# )

def crc32c(data: bytes) -> int:
    """
    Calculates the CRC32C checksum of the provided data.

    Args:
        data: the bytes over which the checksum should be calculated.

    Returns:
        An int representing the CRC32C checksum of the provided bytes.
    """
    import crcmod  # type: ignore

    crc32c_fun = crcmod.predefined.mkPredefinedCrcFun("crc-32c")
    return crc32c_fun(data)

def generate_random_bytes(project_id: str, location: str, num_bytes: int) -> bytes:
    """
    Generate random bytes with entropy sourced from the given location.

    Args:
        project_id (string): Google Cloud project ID (e.g. 'my-project').
        location (string): Cloud KMS location (e.g. 'us-east1').
        num_bytes (integer): number of bytes of random data.

    Returns:
        bytes: Encrypted ciphertext.

    """

    # Create the client.
    client = kms.KeyManagementServiceClient()

    # Build the location name.
    location_name = client.common_location_path(project_id, location)

    # Call the API.
    protection_level = kms.ProtectionLevel.HSM
    random_bytes_response = client.generate_random_bytes(
        request={
            "location": location_name,
            "length_bytes": num_bytes,
            "protection_level": protection_level,
        }
    )

    return dict(data=random_bytes_response.data, crc32c=random_bytes_response.data_crc32c)

def gcp_encrypt_symmetric(
    project_id: str, location: str, keyring_name: str, kek_name: str, plaintext: str
) -> bytes:
    """
    Encrypt plaintext using a symmetric key stored in GCP KMS.

    Args:
        project_id (string): Google Cloud project ID (e.g. 'my-project').
        location (string): Cloud KMS location (e.g. 'us-east1').
        keyring_name (string): Name of the Cloud KMS key ring (e.g. 'my-key-ring').
        kek_name (string): Name of the key to use (e.g. 'my-key').
        plaintext (string): message to encrypt

    Returns:
        bytes: Encrypted ciphertext.

    """

    # Convert the plaintext to bytes.
    plaintext_bytes = plaintext.encode("utf-8")

    # Optional, but recommended: compute plaintext's CRC32C.
    # See crc32c() function defined below.
    plaintext_crc32c = crc32c(plaintext_bytes)

    # Create the client.
    client = kms.KeyManagementServiceClient()

    # Build the key name.
    kek_name = client.crypto_key_path(project_id, location, keyring_name, kek_name)

    # Call the API.
    encrypt_response = client.encrypt(
        request={
            "name": kek_name,
            "plaintext": plaintext_bytes,
            "plaintext_crc32c": plaintext_crc32c,
        }
    )

    # Optional, but recommended: perform integrity verification on encrypt_response.
    # For more details on ensuring E2E in-transit integrity to and from Cloud KMS visit:
    # https://cloud.google.com/kms/docs/data-integrity-guidelines
    if not encrypt_response.verified_plaintext_crc32c:
        raise Exception("The request sent to the server was corrupted in-transit.")
    if not encrypt_response.ciphertext_crc32c == crc32c(encrypt_response.ciphertext):
        raise Exception(
            "The response received from the server was corrupted in-transit."
        )
    # End integrity verification

    return encrypt_response

def gcp_decrypt_symmetric(
    project_id: str, location: str, keyring_name: str, kek_name: str, ciphertext: bytes
) -> kms.DecryptResponse:
    """
    Decrypt the ciphertext using the symmetric key stored in GCP KMS

    Args:
        project_id (string): Google Cloud project ID (e.g. 'my-project').
        location (string): Cloud KMS location (e.g. 'us-east1').
        keyring_name (string): Name of the Cloud KMS key ring (e.g. 'my-key-ring').
        kek_name (string): Name of the key to use (e.g. 'my-key').
        ciphertext (bytes): Encrypted bytes to decrypt.

    Returns:
        DecryptResponse: Response including plaintext.

    """

    # Create the client.
    client = kms.KeyManagementServiceClient()

    # Build the key name.
    kek_name = client.crypto_key_path(project_id, location, keyring_name, kek_name)

    # Optional, but recommended: compute ciphertext's CRC32C.
    # See crc32c() function defined below.
    ciphertext_crc32c = crc32c(ciphertext)

    # Call the API.
    decrypt_response = client.decrypt(
        request={
            "name": kek_name,
            "ciphertext": ciphertext,
            "ciphertext_crc32c": ciphertext_crc32c,
        }
    )

    # Optional, but recommended: perform integrity verification on decrypt_response.
    # For more details on ensuring E2E in-transit integrity to and from Cloud KMS visit:
    # https://cloud.google.com/kms/docs/data-integrity-guidelines
    if not decrypt_response.plaintext_crc32c == crc32c(decrypt_response.plaintext):
        raise Exception(
            "The response received from the server was corrupted in-transit."
        )
    # End integrity verification

    return decrypt_response

def local_encrypt_symmetric(data_encryption_key: bytes, plaintext: str) -> bytes:
    """
    Encrypt plaintext using a symmetric key.

    Args:
        data_encryption_key (bytes): DEK bytes to be used on encrypt process.
        plaintext (string): message to encrypt

    Returns:
        dict: base64 encrypted ciphertext.

    """
    f = Fernet(data_encryption_key)
    return f.encrypt(plaintext.encode())

def local_decrypt_symmetric(data_encryption_key: bytes, ciphertext: bytes) -> bytes:
    """
    Decrypt ciphertext using a symmetric key.

    Args:
        data_encryption_key (bytes): DEK bytes to be used on encrypt process.
        ciphertext (bytes): ciphertext to decrypt

    Returns:
        bytes: decrypted plaintext.

    """
    f = Fernet(data_encryption_key)
    return f.decrypt(ciphertext)

def save_json_to_file(json_data: str, file_path: str) -> None:

    """
    Save a JSON object to a file.

    Parameters:
    json_data (dict): The JSON object to save.
    file_path (str): The path to the file where the JSON object should be saved.

    """
    try:
        with open(file_path, 'w') as file:
            json.dump(json_data, file, indent=4)
        print(f"JSON data successfully saved to {file_path}")
    except Exception as e:
        print(f"An error occurred while saving JSON data to file: {e}")
        raise e

def load_json_from_file(file_path: str) -> dict:
    """
    Load a JSON object from a file.

    Parameters:
    file_path (str): The path to the file where the JSON object is stored.

    Returns:
    dict: The JSON object loaded from the file.

    """
    try:
        with open(file_path, 'r') as file:
            json_data = json.load(file)
        print(f"JSON data successfully loaded from {file_path}")
        return json_data
    except Exception as e:
        print(f"An error occurred while loading JSON data from file: {e}")
        raise e

def read_text_file(file_path: str) -> str:
    """
    Read a simple text file.

    Parameters:
    file_path (str): The path to the file where the desired text is stored.

    Returns:
    str: The text content of the file.

    """
    file = open(file_path, "r")
    return file.read()

def main(argv):

    mode = FLAGS.mode
    project_id = FLAGS.project_id
    kek_name = FLAGS.kek_name
    keyring_name = FLAGS.keyring_name
    location = FLAGS.location
    num_bytes = FLAGS.num_bytes
    wrapped_key_path = FLAGS.wrapped_key_path
    input = FLAGS.input
    output = FLAGS.output

    if FLAGS.mode == 'generate':
        random_bytes_response = generate_random_bytes(
            project_id=project_id,
            location=location,
            num_bytes=num_bytes
        )
        decoded_dek = b64encode(random_bytes_response['data']).decode('utf-8')

        wrapped_key = gcp_encrypt_symmetric(
            project_id=project_id,
            location=location,
            keyring_name=keyring_name,
            kek_name=kek_name,
            plaintext=decoded_dek
        )
        save_json_to_file(
            json_data=b64encode(wrapped_key.ciphertext).decode('utf-8'),
            file_path=wrapped_key_path
        )

    if FLAGS.mode == 'encrypt':
        wrapped_key = load_json_from_file(wrapped_key_path)
        key = gcp_decrypt_symmetric(
            project_id=project_id,
            location=location,
            keyring_name=keyring_name,
            kek_name=kek_name,
            ciphertext=b64decode(wrapped_key)
        )
        content = read_text_file(input)

        ciphertext = local_encrypt_symmetric(
            data_encryption_key=key.plaintext,
            plaintext=content
        )

        save_json_to_file(
            json_data=b64encode(ciphertext).decode('utf-8'),
            file_path=output
        )

    if FLAGS.mode == 'decrypt':
        wrapped_key = load_json_from_file(wrapped_key_path)
        key = gcp_decrypt_symmetric(
            project_id=project_id,
            location=location,
            keyring_name=keyring_name,
            kek_name=kek_name,
            ciphertext=b64decode(wrapped_key)
        )
        content = read_text_file(input)

        plaintext = local_decrypt_symmetric(
            data_encryption_key=key.plaintext,
            ciphertext=b64decode(content)
        )

        save_json_to_file(
            json_data=plaintext.decode('utf-8'),
            file_path=output
        )

if __name__ == "__main__":
    app.run(main)
