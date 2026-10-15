/**
 * Copyright 2026 Google LLC
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

provider "google" {
  project = var.project_id
  region  = var.location
}

data "google_client_openid_userinfo" "current" {}

locals {
  caller_is_service_account = can(regex("\\.gserviceaccount\\.com$", data.google_client_openid_userinfo.current.email))
  caller_member             = "${local.caller_is_service_account ? "serviceAccount" : "user"}:${data.google_client_openid_userinfo.current.email}"
}

data "google_kms_crypto_key_version" "primary" {
  crypto_key = module.kms.keys[var.key_name]

  depends_on = [module.kms]
}

resource "google_project_service" "kms" {
  count              = var.enable_services ? 1 : 0
  project            = var.project_id
  service            = "cloudkms.googleapis.com"
  disable_on_destroy = false
}

module "kms" {
  source  = "terraform-google-modules/kms/google"
  version = "~> 4.1"

  project_id      = var.project_id
  location        = var.location
  keyring         = var.keyring_name
  keys            = [var.key_name]
  prevent_destroy = var.prevent_destroy

  key_algorithm        = var.algorithm
  key_protection_level = var.key_protection_level
  purpose              = var.purpose

  key_rotation_period = var.key_rotation_period

  set_owners_for = [var.key_name]
  owners         = [local.caller_member]

  depends_on = [google_project_service.kms]
}

resource "google_kms_crypto_key_iam_member" "signer_verifier" {
  crypto_key_id = module.kms.keys[var.key_name]
  role          = "roles/cloudkms.signerVerifier"
  member        = local.caller_member
}

resource "google_kms_crypto_key_iam_member" "public_key_viewer" {
  crypto_key_id = module.kms.keys[var.key_name]
  role          = "roles/cloudkms.publicKeyViewer"
  member        = local.caller_member
}
