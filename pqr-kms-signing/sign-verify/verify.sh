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

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <file.pdf> [file.sig]"
  exit 1
fi

PDF_FILE="$1"
SIG_FILE="${2:-${PDF_FILE%.pdf}.sig}"

if [[ ! -f "$PDF_FILE" ]]; then
  echo "Error: PDF file not found: $PDF_FILE"
  exit 1
fi

if [[ ! -f "$SIG_FILE" ]]; then
  echo "Error: signature file not found: $SIG_FILE"
  echo "Run first: ./sign.sh $PDF_FILE"
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

# Prefer a local OpenSSL with ML-DSA support (3.5+); otherwise fall back to Docker.
USE_LOCAL_OPENSSL=false
if command -v openssl &>/dev/null && \
  openssl list -signature-algorithms 2>/dev/null | grep -qi "ML-DSA-87"; then
  USE_LOCAL_OPENSSL=true
elif ! command -v docker &>/dev/null; then
  echo "Error: OpenSSL 3.5+ (with ML-DSA support) or docker is required."
  echo "Please install Docker: https://docs.docker.com/engine/install/"
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

cat <<EOF
Verifying $ALGORITHM signature...
  File      : $PDF_FILE
  Signature : $SIG_FILE
  Project   : $PROJECT
  Location  : $LOCATION
  Key Ring  : $KEYRING
  Key       : $KEY
  Version   : $VERSION

EOF

echo "Exporting public key from KMS..."
PUB_KEY=$(gcloud kms keys versions get-public-key "$VERSION" \
  --project="$PROJECT" \
  --location="$LOCATION" \
  --keyring="$KEYRING" \
  --key="$KEY" \
  --format="value(pem)")
echo ""

WORK_DIR=$(mktemp -d /tmp/ml_dsa_verify_XXXXXX)
trap 'rm -rf "$WORK_DIR"' EXIT
echo "$PUB_KEY" > "$WORK_DIR/pubkey.pem"

if [[ "$USE_LOCAL_OPENSSL" == true ]]; then
  echo "Verifying with local $(openssl version | awk '{print $1, $2}')..."
  VERIFY_RESULT=$(openssl pkeyutl -verify -pubin \
    -inkey "$WORK_DIR/pubkey.pem" \
    -sigfile "$SIG_FILE" \
    -in "$PDF_FILE" \
    2>&1 || true)
else
  echo "Verifying with OpenSSL (alpine/openssl:latest)..."
  VERIFY_RESULT=$(docker run --rm \
    -v "$WORK_DIR/pubkey.pem:/verify/pubkey.pem:ro" \
    -v "$(realpath "$PDF_FILE"):/verify/document.pdf:ro" \
    -v "$(realpath "$SIG_FILE"):/verify/document.sig:ro" \
    --entrypoint openssl \
    alpine/openssl:latest \
    pkeyutl -verify -pubin \
    -inkey /verify/pubkey.pem \
    -sigfile /verify/document.sig \
    -in /verify/document.pdf \
    2>&1 || true)
fi

if echo "$VERIFY_RESULT" | grep -q "Signature Verified Successfully"; then
  echo "Signature is VALID!"
  exit 0
else
  echo "Signature is INVALID!"
  echo "Details: $VERIFY_RESULT"
  exit 1
fi
