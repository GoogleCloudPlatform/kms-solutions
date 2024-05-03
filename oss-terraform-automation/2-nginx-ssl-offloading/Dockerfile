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

FROM nginx:1.25.0-bullseye

# Install the OpenSSL PKCS #11 library
RUN apt-get update && apt-get install -y libengine-pkcs11-openssl wget curl opensc

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
RUN mkdir -p /tmp/libkmsp11 && \
    tar -xf "libkmsp11-${ENV_PKCS11_LIB_VERSION}-linux-amd64.tar.gz" -C /tmp/libkmsp11

RUN echo "---\ntokens:\n  - key_ring: \"projects/${ENV_PROJECT_ID}/locations/${ENV_LOCATION}/keyRings/${ENV_KEYRING_NAME}\"\nlog_directory: \"/var/log/kmsp11\"" > /etc/nginx/pkcs11-config.yaml

# Export PKCS #11 required env vars
ENV PKCS11_MODULE_PATH="/tmp/libkmsp11/libkmsp11-${ENV_PKCS11_LIB_VERSION}-linux-amd64/libkmsp11.so"
ENV KMS_PKCS11_CONFIG="/etc/nginx/pkcs11-config.yaml"
ENV GRPC_ENABLE_FORK_SUPPORT=1

# Create a self-signed certificate with the Cloud KMS-hosted signing key
RUN openssl req -new -x509 -days 3650 -subj '/CN='${ENV_CERTIFICATE_NAME}'/' \
  -${ENV_DIGEST_FLAG} -engine pkcs11 -keyform engine \
  -key pkcs11:object=${ENV_KEY_NAME} > /tmp/ca.cert

# Override the self-signed certificate if user provided a certificate as an input
RUN [ -n "$ENV_CERTIFICATE_FILE" ] && echo "$ENV_CERTIFICATE_FILE" > /tmp/ca.cert || true

RUN mkdir /etc/ssl/nginx
RUN mv /tmp/ca.cert /etc/ssl/nginx

RUN mkdir /var/log/kmsp11
RUN chown www-data /var/log/kmsp11
RUN chmod 666 /var/log/kmsp11
RUN chmod 744 /etc/nginx/pkcs11-config.yaml

# Add SSL configuration after the NGINX events block at /etc/nginx/nginx.conf file
ENV STRING_BLOCK_1="\n\nssl_engine pkcs11;\nenv KMS_PKCS11_CONFIG=/etc/nginx/pkcs11-config.yaml;"
RUN awk '/}/ && !inserted {print $0 "'"$STRING_BLOCK_1"'"; inserted=1; next} {print}' /etc/nginx/nginx.conf > tmpfile && mv tmpfile /etc/nginx/nginx.conf

# Add SSL configuration in NGINX http block at /etc/nginx/nginx.conf file
ENV STRING_BLOCK_2='\n    ssl_certificate \"/etc/ssl/nginx/ca.cert\";\n    ssl_certificate_key \"engine:pkcs11:pkcs11:object='${ENV_KEY_NAME}'\";\n    ssl_protocols TLSv1.2 TLSv1.3;\n    ssl_prefer_server_ciphers on;'
RUN awk '/http {/ && !inserted {print $0 "'"$STRING_BLOCK_2"'"; inserted=1; next} {print}' /etc/nginx/nginx.conf > tmpfile && mv tmpfile /etc/nginx/nginx.conf

# Add SSL configuration in NGIX server block in /etc/nginx/conf.d/default.conf file
ENV STRING_BLOCK_3="\n    listen 443 ssl default_server;\n    listen [::]:443 ssl default_server;"
RUN awk '/server {/ && !inserted {print $0 "'"$STRING_BLOCK_3"'"; inserted=1; next} {print}' /etc/nginx/conf.d/default.conf > tmpfile && mv tmpfile /etc/nginx/conf.d/default.conf

# Add environment variables in NGINX service block at /lib/systemd/system/nginx.service file
ENV STRING_BLOCK_4='\nEnvironment=\"GRPC_ENABLE_FORK_SUPPORT=1\"\nEnvironment=\"KMS_PKCS11_CONFIG=/etc/nginx/pkcs11-config.yaml\"\nEnvironment=\"PKCS11_MODULE_PATH='${PKCS11_MODULE_PATH}'\"'
RUN awk '/Service]/ && !inserted {print $0 "'"$STRING_BLOCK_4"'"; inserted=1; next} {print}' /lib/systemd/system/nginx.service > tmpfile && mv tmpfile /lib/systemd/system/nginx.service

# Restart apache service
RUN /etc/init.d/nginx restart

EXPOSE 443

# Command to start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
