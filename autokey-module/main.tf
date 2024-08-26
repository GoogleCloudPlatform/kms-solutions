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
  default_suffix     = var.suffix != "" ? var.suffix : random_string.suffix.result
  autokey_project_id = "${var.autokey_project_id}-${local.default_suffix}"
  autokey_folder     = "${var.autokey_folder}-${local.default_suffix}"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_folder" "autokms_folder" {
  count = var.create_autokey_folder ? 1 : 0

  provider     = google-beta
  display_name = local.autokey_folder
  parent       = var.autokey_parent
}

module "autokey-project" {
  count = var.create_autokey_project ? 1 : 0

  source  = "terraform-google-modules/project-factory/google"
  version = "~> 16.0"

  project_id = var.create_autokey_project ? local.autokey_project_id : var.autokey_project_id
  folder_id  = var.create_autokey_folder ? google_folder.autokms_folder[0].folder_id : var.autokey_folder

  name            = var.autokey_project_name
  billing_account = var.billing_account

  activate_api_identities = [{
    api = "cloudkms.googleapis.com"
    roles = [
      "roles/cloudkms.admin"
    ]
  }]

  depends_on = [google_folder.autokms_folder]
}

data "google_project" "autokey_project" {
  count = var.create_autokey_project ? 0 : 1

  project_id = var.autokey_project_id
}

resource "google_project_service" "enable_kms_api" {
  count = var.create_autokey_project ? 0 : 1

  project = var.autokey_project_id
  service = "cloudkms.googleapis.com"

  disable_on_destroy = false
}

resource "time_sleep" "wait_kms_api" {
  count = var.create_autokey_project ? 0 : 1

  create_duration = "10s"
  depends_on      = [google_project_service.enable_kms_api]
}

resource "google_project_service_identity" "enable_kms_sa" {
  provider = google-beta
  count    = var.create_autokey_project ? 0 : 1

  service    = "cloudkms.googleapis.com"
  project    = var.autokey_project_id
  depends_on = [time_sleep.wait_kms_api]
}

resource "google_project_iam_member" "kms_sa_admin" {
  count = var.create_autokey_project ? 0 : 1

  project = var.autokey_project_id
  role    = "roles/cloudkms.admin"
  member  = "serviceAccount:service-${data.google_project.autokey_project[0].number}@gcp-sa-cloudkms.iam.gserviceaccount.com"

  depends_on = [google_project_service_identity.enable_kms_sa]
}

resource "time_sleep" "wait_setup" {
  create_duration = "30s"
  depends_on = [
    module.autokey-project,
    google_folder.autokms_folder,
    google_project_iam_member.kms_sa_admin
  ]
}

resource "google_kms_autokey_config" "autokeyconfig" {
  provider    = google-beta
  folder      = var.create_autokey_folder ? google_folder.autokms_folder[0].folder_id : var.autokey_folder
  key_project = var.create_autokey_project ? "projects/${module.autokey-project[0].project_id}" : "projects/${var.autokey_project_id}"
  depends_on  = [time_sleep.wait_setup]
}
