#!/usr/bin/env python3

# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import argparse
from google.cloud import kms_v1
from base64 import b64decode

# Define the argument parser
parser = argparse.ArgumentParser()

# Add arguments
parser.add_argument("--ciphertext", required=True, help="Ciphertext in base64")
parser.add_argument("--iv", required=True, help="Initialization Vector in base64")
parser.add_argument("--aad", required=True, help="Additional Authenticated Data")
parser.add_argument("--gcp_project", required=True, help="GCP Project ID")
parser.add_argument("--gcp_location", required=True, help="GCP KMS Location")
parser.add_argument("--gcp_keyring", required=True, help="GCP KMS Keyring")
parser.add_argument("--gcp_key", required=True, help="GCP Key")
parser.add_argument("--gcp_key_version", help="GCP Key Version", default="1")

# Parse the arguments
args = parser.parse_args()

# Access the parameters and convert what is needed
ciphertext = b64decode(args.ciphertext)
iv = b64decode(args.iv)
aad = str(args.aad).encode()

# Create a client
client = kms_v1.KeyManagementServiceClient()

# Initialize request argument(s)
key_identifier = f"projects/{args.gcp_project}/locations/{args.gcp_location}/keyRings/{args.gcp_keyring}/cryptoKeys/{args.gcp_key}/cryptoKeyVersions/{args.gcp_key_version}"

request = kms_v1.RawDecryptRequest(
    name=key_identifier,
    ciphertext=ciphertext,
    initialization_vector=iv,
    additional_authenticated_data=aad,
)

# Make the decrypt request
response = client.raw_decrypt(request=request)

# Handle the response
print(response)
