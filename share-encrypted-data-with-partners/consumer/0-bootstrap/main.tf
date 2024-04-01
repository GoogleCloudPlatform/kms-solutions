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

locals {
  default_suffix = var.suffix != "" ? var.suffix : random_string.suffix.result
  apis_to_enable = [
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}

resource "google_project_service" "apis_to_enable" {
  for_each = toset(local.apis_to_enable)

  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}

resource "time_sleep" "enable_projects_apis_sleep" {
  create_duration = "30s"

  depends_on = [google_project_service.apis_to_enable]
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_kms_key_ring" "keyring" {
  name     = "${var.keyring}-${local.default_suffix}"
  location = var.location
  project  = var.project_id

  depends_on = [time_sleep.enable_projects_apis_sleep]
}

resource "google_kms_crypto_key" "dek-prevent-destroy-true" {
  count = var.prevent_destroy ? 1 : 0

  name                          = "${var.key}-${local.default_suffix}"
  key_ring                      = google_kms_key_ring.keyring.id
  purpose                       = "RAW_ENCRYPT_DECRYPT"
  import_only                   = true
  skip_initial_version_creation = true

  version_template {
    algorithm        = var.crypto_key_algorithm_template
    protection_level = "HSM"
  }

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [time_sleep.enable_projects_apis_sleep]
}

resource "google_kms_crypto_key" "dek-prevent-destroy-false" {
  count = var.prevent_destroy ? 0 : 1

  name                          = "${var.key}-${local.default_suffix}"
  key_ring                      = google_kms_key_ring.keyring.id
  purpose                       = "RAW_ENCRYPT_DECRYPT"
  import_only                   = true
  skip_initial_version_creation = true

  version_template {
    algorithm        = var.crypto_key_algorithm_template
    protection_level = "HSM"
  }

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [time_sleep.enable_projects_apis_sleep]
}
