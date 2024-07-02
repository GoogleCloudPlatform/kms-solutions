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

FROM ubuntu/apache2:2.4-22.04_beta

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

RUN echo "---\ntokens:\n  - key_ring: \"projects/${ENV_PROJECT_ID}/locations/${ENV_LOCATION}/keyRings/${ENV_KEYRING_NAME}\"\n" > /opt/libkmsp11/kms-pkcs11.conf

# Export PKCS #11 required env vars
ENV PKCS11_MODULE_PATH="/opt/libkmsp11/libkmsp11-${ENV_PKCS11_LIB_VERSION}-linux-amd64/libkmsp11.so"
ENV KMS_PKCS11_CONFIG="/opt/libkmsp11/kms-pkcs11.conf"
ENV GRPC_ENABLE_FORK_SUPPORT=1

# Create a self-signed certificate with the Cloud KMS-hosted signing key
RUN openssl req -new -x509 -days 365 -subj '/CN='${ENV_CERTIFICATE_NAME}'/' \
  -${ENV_DIGEST_FLAG} -engine pkcs11 -keyform engine \
  -key pkcs11:object=${ENV_KEY_NAME} > /opt/ca.cert

# Override the self-signed certificate if user provided a certificate as an input
RUN [ -n "$ENV_CERTIFICATE_FILE" ] && echo "$ENV_CERTIFICATE_FILE" > /opt/ca.cert || true

RUN mkdir /etc/apache2/ssl
RUN mv /opt/ca.cert /etc/apache2/ssl

# Add the SSL conf to the Apache configuration file
RUN echo "<VirtualHost *:443>\n\
        ServerAdmin webmaster@localhost\n\
        DocumentRoot /var/www/html\n\
        ErrorLog \${APACHE_LOG_DIR}/error.log\n\
        CustomLog \${APACHE_LOG_DIR}/access.log combined\n\
        SSLEngine on\n\
        SSLCertificateFile /etc/apache2/ssl/ca.cert\n\
        SSLCertificateKeyFile \"pkcs11:object=${ENV_KEY_NAME}\"\n\
  </VirtualHost>" >> /etc/apache2/sites-available/000-default.conf

# Enable the Apache SSL module, enable the virtualhost configuration, and add a test web page in your DocumentRoot folder
RUN a2enmod ssl
RUN a2ensite 000-default.conf
RUN echo '<!doctype html><html><body><h1>Hello World!</h1></body></html>' | \
 tee /var/www/html/index.html

EXPOSE 443

# Start Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
