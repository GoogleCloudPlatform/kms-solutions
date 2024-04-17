/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#####
# Script to create resources
#####

data "google_project" "kms_project" {
  project_id = var.kms_project_id
}

data "google_project" "vpc_project" {
  project_id = var.vpc_project_id == "" ? var.kms_project_id : var.vpc_project_id
}

# User Credentials (Default: Current logged in user)
data "google_client_openid_userinfo" "provider_identity" {
}

resource "google_project_service_identity" "enable_ekm_service_agent" {
  provider = google-beta

  project = data.google_project.kms_project.number
  service = "cloudkms.googleapis.com"
}

#EKM Connection Creation
resource "google_kms_ekm_connection" "ekm_main_resource" {
  name                = var.ekmconnection_name
  location            = var.location
  key_management_mode = var.key_management_mode
  project             = var.kms_project_id
  service_resolvers {
    service_directory_service = google_service_directory_service.sd_service.id
    hostname                  = var.external_provider_hostname
    server_certificates {
      raw_der = var.external_provider_raw_der
    }
  }
  crypto_space_path = var.crypto_space_path
}

# #Key Ring Creation
resource "google_kms_key_ring" "vpc_kms_ring" {
  name     = "${var.kms_name_prefix}-keyring"
  location = var.location
  project  = var.kms_project_id
}

# #Key Creation
resource "google_kms_crypto_key" "vpc_key" {
  name     = "${var.kms_name_prefix}-key"
  key_ring = google_kms_key_ring.vpc_kms_ring.id
  purpose  = "ENCRYPT_DECRYPT"

  version_template {
    algorithm        = "EXTERNAL_SYMMETRIC_ENCRYPTION"
    protection_level = "EXTERNAL_VPC"
  }
  skip_initial_version_creation = true
  crypto_key_backend            = google_kms_ekm_connection.ekm_main_resource.id
}
resource "google_kms_crypto_key_version" "vpc_crypto_key_version" {
  crypto_key = google_kms_crypto_key.vpc_key.id
  external_protection_level_options {
    ekm_connection_key_path = var.ekm_connection_key_path
  }
}
