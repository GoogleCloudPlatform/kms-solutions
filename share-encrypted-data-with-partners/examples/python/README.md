# Raw Encryption: Example of sharing encrypted data with partners using Python

## Overview

This guide provides a raw encryption data sharing example using Python.

## Prerequisites

- [Python 3+](https://www.python.org/downloads/);
- [pip](https://pip.pypa.io/en/stable/installation/);
- (For consumer/decrypt only) [Google Cloud CLI (`gcloud`)](https://cloud.google.com/sdk/docs/install-sdk);
    - You must be authenticated in your GCP account. If you're not, you should run `gcloud auth login`;

**Note:** It is recommended that you create and enable a Python [virtual environment](https://docs.python.org/3/library/venv.html) before starting this tutorial.

## Glossary

- AAD: Additional Authenticated Data
    - The AAD is used for authentication purposes, to ensure the ciphertext has not been altered.
- IV: Initialization Vector
    - The IV, which should be generated randomly, is used as a parameter to make the encryption semantically secure.

## Install dependencies

1. Install dependencies using `pip`.
    ```sh
    pip install -r requirements.txt
    ```

## Encrypt and decrypt sensitive data

1. (For producer only) Run the encrypt script passing DEK file, data, and AAD as inputs.
    ```sh
    python encrypt.py \
    --data_encryption_key_path "REPLACE-WITH-YOUR-DEK-PATH" \
    --data "a secret message to be shared" \
    --aad "pre-determined authenticated but unencrypted data"
    ```
    **Note:** The outputs provided by this script would be the ciphertext, IV, and AAD. These should be shared with consumer. They will be required to run the decrypt script.

1. (For consumer only) Run the decrypt script passing ciphertext, IV and AAD and your GCP info.
    ```sh
    python decrypt.py \
    --ciphertext "REPLACE-WITH-YOUR-CIPHERTEXT" \
    --iv "REPLACE-WITH-YOUR-IV" \
    --aad "pre-determined authenticated but unencrypted data" \
    --gcp_project "REPLACE-WITH-YOUR-PROJECT-ID" \
    --gcp_location "REPLACE-WITH-YOUR-KMS-LOCATION" \
    --gcp_keyring "REPLACE-WITH-YOUR-KEYRING" \
    --gcp_key "REPLACE-WITH-YOUR-KEY"
    ```
    **Note:** `--gcp_key_version` parameter is optional. If not provided the default will be "1".
