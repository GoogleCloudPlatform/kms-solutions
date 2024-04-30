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

FROM ubuntu:latest

# Install the OpenSSL PKCS #11 library
RUN apt-get update && apt-get install -y libengine-pkcs11-openssl wget curl

# Using ARGs so user can provide the custom variables required to create pkcs11 config file
ARG PROJECT_ID
ENV ENV_PROJECT_ID=$PROJECT_ID

ARG KEYRING_NAME
ENV ENV_KEYRING_NAME=$KEYRING_NAME

ARG KEY_NAME
ENV ENV_KEY_NAME=$KEY_NAME

ARG LOCATION
ENV ENV_LOCATION=$LOCATION

ARG PKCS11_LIB_VERSION
ENV ENV_PKCS11_LIB_VERSION=$PKCS11_LIB_VERSION

ARG CERTIFICATE_NAME
ENV ENV_CERTIFICATE_NAME=$CERTIFICATE_NAME

ARG CERTIFICATE_FILE
ENV ENV_CERTIFICATE_FILE=$CERTIFICATE_FILE

ARG DIGEST_FLAG
ENV ENV_DIGEST_FLAG=$DIGEST_FLAG

# Download the GCP pkcs11 library
RUN wget "https://github.com/GoogleCloudPlatform/kms-integrations/releases/download/pkcs11-v${ENV_PKCS11_LIB_VERSION}/libkmsp11-${ENV_PKCS11_LIB_VERSION}-linux-amd64.tar.gz"

# Extract the library to a specific directory
RUN mkdir -p /opt/libkmsp11 && \
    tar -xf "libkmsp11-${ENV_PKCS11_LIB_VERSION}-linux-amd64.tar.gz" -C /opt/libkmsp11

RUN echo "---\ntokens:\n  - key_ring: \"projects/${ENV_PROJECT_ID}/locations/${ENV_LOCATION}/keyRings/${ENV_KEYRING_NAME}\"\nlog_directory: \"/opt/libkmsp11/log/kmsp11\"" > /opt/libkmsp11/pkcs11-config.yaml

# Export PKCS #11 required env vars
ENV PKCS11_MODULE_PATH="/opt/libkmsp11/libkmsp11-${ENV_PKCS11_LIB_VERSION}-linux-amd64/libkmsp11.so"
ENV KMS_PKCS11_CONFIG="/opt/libkmsp11/pkcs11-config.yaml"
ENV GRPC_ENABLE_FORK_SUPPORT=1

# Create a self-signed certificate with the Cloud KMS-hosted signing key
RUN openssl req -new -x509 -days 3650 -subj '/CN='${ENV_CERTIFICATE_NAME}'/' \
  -${ENV_DIGEST_FLAG} -engine pkcs11 -keyform engine \
  -key pkcs11:object=${ENV_KEY_NAME} > /opt/ca.cert

# Override the self-signed certificate if user provided a certificate as an input
RUN [ -n "$ENV_CERTIFICATE_FILE" ] && echo "$ENV_CERTIFICATE_FILE" > /opt/ca.cert || true

# Create a new certificate signing request (CSR) for a Cloud HSM signing key
RUN openssl req -new -subj '/CN='${ENV_CERTIFICATE_NAME}'/' -${ENV_DIGEST_FLAG} \
  -engine pkcs11 -keyform engine \
  -key pkcs11:object=${ENV_KEY_NAME} > /opt/request-ca.csr

RUN mkdir /opt/libkmsp11/log/
RUN mkdir /opt/libkmsp11/log/kmsp11
RUN chown www-data /opt/libkmsp11/log/kmsp11
RUN chmod 666 /opt/libkmsp11/log/kmsp11
RUN chmod 744 /opt/libkmsp11/pkcs11-config.yaml

# Command to keep the container running without executing any application
CMD ["tail", "-f", "/dev/null"]
