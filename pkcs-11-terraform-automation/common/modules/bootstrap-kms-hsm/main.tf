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
    "compute.googleapis.com",
    "iam.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudkms.googleapis.com"
  ]
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_project_service" "apis_to_enable" {
  for_each = toset(local.apis_to_enable)

  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}

module "kms" {
  source  = "terraform-google-modules/kms/google"
  version = "2.2.3"

  keyring              = "${var.keyring}-${local.default_suffix}"
  location             = var.location
  project_id           = var.project_id
  keys                 = ["${var.key}-${local.default_suffix}"]
  purpose              = "ASYMMETRIC_SIGN"
  key_algorithm        = "EC_SIGN_P256_SHA256"
  key_protection_level = "HSM"
  key_rotation_period  = ""
  prevent_destroy      = var.prevent_destroy
}

resource "google_artifact_registry_repository" "pkcs11_hsm_examples" {
  location      = var.location
  project       = var.project_id
  repository_id = "${var.artifact_repository}-${local.default_suffix}"
  description   = "This repo stores images of the PKCS #11 library usage examples using Cloud HSM."
  format        = "DOCKER"
}
