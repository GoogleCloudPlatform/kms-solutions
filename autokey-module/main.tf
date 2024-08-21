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
  kms_project_id = "${var.kms_project_id}-${local.default_suffix}"
  autokey_folder = "${var.autokey_folder}-${local.default_suffix}"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_folder" "autokms_folder" {
  provider     = google-beta
  display_name = local.autokey_folder
  parent       = var.autokey_parent
}

module "kms-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 16.0"

  project_id = local.kms_project_id
  folder_id  = google_folder.autokms_folder.folder_id

  name            = var.kms_project_name
  billing_account = var.billing_account

  activate_api_identities = [{
    api = "cloudkms.googleapis.com"
    roles = [
      "roles/cloudkms.admin"
    ]
  }]

  depends_on = [google_folder.autokms_folder]
}

resource "time_sleep" "wait_project_setup" {
  create_duration = "10s"
  depends_on      = [module.kms-project]
}

resource "google_kms_autokey_config" "autokeyconfig" {
  provider    = google-beta
  folder      = google_folder.autokms_folder.folder_id
  key_project = "projects/${module.kms-project.project_id}"
  depends_on  = [time_sleep.wait_project_setup]
}
