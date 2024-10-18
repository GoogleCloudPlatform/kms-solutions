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
  default_suffix         = var.suffix != "" ? var.suffix : random_string.suffix.result
  autokey_key_project_id = var.create_autokey_key_project ? module.autokey_key_project[0].project_id : var.autokey_key_project_id
  autokey_folder_id      = var.create_autokey_folder ? google_folder.autokey_resource_folder[0].folder_id : var.autokey_folder_id
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_folder" "autokey_resource_folder" {
  count = var.create_autokey_folder ? 1 : 0

  provider            = google-beta
  display_name        = "${var.autokey_folder_id}-${local.default_suffix}"
  parent              = var.autokey_parent
  deletion_protection = var.folder_deletion_protection
}

module "autokey_key_project" {
  count = var.create_autokey_key_project ? 1 : 0

  source  = "terraform-google-modules/project-factory/google"
  version = "~> 17.0"

  project_id      = "${var.autokey_key_project_id}-${local.default_suffix}"
  folder_id       = local.autokey_folder_id
  deletion_policy = var.deletion_policy

  name            = var.autokey_key_project_name
  billing_account = var.billing_account

  activate_api_identities = [{
    api = "cloudkms.googleapis.com"
    roles = [
      "roles/cloudkms.admin"
    ]
  }]

  depends_on = [google_folder.autokey_resource_folder]
}
