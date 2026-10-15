#!/bin/bash

# Copyright 2026 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <file.pdf>"
  exit 1
fi

PDF_FILE="$1"

if [[ ! -f "$PDF_FILE" ]]; then
  echo "Error: file not found: $PDF_FILE"
  exit 1
fi

if [[ -z "${KMS_KEY_URI:-}" ]]; then
  echo "Error: KMS_KEY_URI environment variable is not set."
  echo "Run: export KMS_KEY_URI=\$(terraform output -raw kms_key_uri)"
  exit 1
fi

if ! command -v gcloud &>/dev/null; then
  echo "Error: gcloud CLI not found."
  exit 1
fi

KMS_RESOURCE="${KMS_KEY_URI#gcp-kms://}"

PROJECT=$(echo "$KMS_RESOURCE"  | cut -d'/' -f2)
LOCATION=$(echo "$KMS_RESOURCE" | cut -d'/' -f4)
KEYRING=$(echo "$KMS_RESOURCE"  | cut -d'/' -f6)
KEY=$(echo "$KMS_RESOURCE"      | cut -d'/' -f8)
VERSION=$(echo "$KMS_RESOURCE"  | cut -d'/' -f10)

ALGORITHM=$(gcloud kms keys versions describe "$VERSION" \
  --project="$PROJECT" \
  --location="$LOCATION" \
  --keyring="$KEYRING" \
  --key="$KEY" \
  --format="value(algorithm)")

SIG_FILE="${PDF_FILE%.pdf}.sig"

cat <<EOF
Signing file with $ALGORITHM via GCP KMS...
  File      : $PDF_FILE
  Project   : $PROJECT
  Location  : $LOCATION
  Key Ring  : $KEYRING
  Key       : $KEY
  Version   : $VERSION
  Algorithm : $ALGORITHM
  Output    : $SIG_FILE
EOF

gcloud kms asymmetric-sign \
  --project="$PROJECT" \
  --location="$LOCATION" \
  --keyring="$KEYRING" \
  --key="$KEY" \
  --version="$VERSION" \
  --input-file="$PDF_FILE" \
  --signature-file="$SIG_FILE"

SIG_SIZE=$(wc -c < "$SIG_FILE")
echo "Signature generated successfully!"
echo "  File : $SIG_FILE"
echo "  Size : $SIG_SIZE bytes (expected ~4627 bytes for ML-DSA-87)"
