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

module "autokey-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 16.0"

  random_project_id = true
  name              = "autokey-test"
  folder_id         = var.folder_id
  billing_account   = var.billing_account

  activate_api_identities = [{
    api = "cloudkms.googleapis.com"
    roles = [
      "roles/cloudkms.admin"
    ]
  }]
}

resource "google_folder" "test_autokey_folder" {
  display_name = "autokey_${var.suffix}"
  parent       = "folders/${var.folder_id}"
}

module "autokey" {
  source = "../../autokey-module"

  autokey_parent         = "folders/${var.folder_id}"
  billing_account        = var.billing_account
  create_autokey_project = false
  create_autokey_folder  = false
  autokey_project_id     = module.autokey-project.project_id
  autokey_folder         = google_folder.test_autokey_folder.folder_id
}
