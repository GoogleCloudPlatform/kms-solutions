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

import os
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import argparse
import json
from base64 import b64encode

# Define the argument parser
parser = argparse.ArgumentParser()

# Add arguments
parser.add_argument(
    "--data_encryption_key_path", required=True, help="DEK path"
)
parser.add_argument("--data", required=True, help="Sensitive data")
parser.add_argument(
    "--aad", required=True, help="Additional Authenticated Data"
)
parser.add_argument(
    "--json", required=False, action="store_true",
    help="Format output as JSON", default=False,
)

# Parse the arguments
args = parser.parse_args()

# Access the parameters
data_encryption_key_path = args.data_encryption_key_path
data = str(args.data).encode()
aad = str(args.aad)

# Reading key bytes
key = open(data_encryption_key_path, "rb").read()
aesgcm = AESGCM(key)
nonce = os.urandom(12)

# Encrypting data with key bytes
ciphertext = aesgcm.encrypt(nonce, data, aad.encode())

# Printing the outputs needed for decrypt process
ciphertext = b64encode(ciphertext)
nonce = b64encode(nonce)

if bool(args.json):
    print(json.dumps(
        dict(
            ciphertext=ciphertext.decode("utf-8"),
            iv=nonce.decode("utf-8"),
            aad=aad,
        )
    )
    )
else:
    print(f"Ciphertext base 64: {ciphertext}")
    print(f"Generated IV base64 for encryption: {nonce}")
    print(f"Additional Authenticated Data (AAD): {aad}")
