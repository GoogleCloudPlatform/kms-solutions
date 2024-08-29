/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module "aw_mgmt_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 16.0"

  project_id                  = "${var.aw_base_id}-mgmt-${local.default_suffix}"
  disable_services_on_destroy = true
  org_id                      = var.organization_id
  folder_id                   = var.aw_root_folder_id
  name                        = "${var.aw_base_id} Management"
  billing_account             = var.billing_account_id
  activate_apis = [
    "assuredworkloads.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}
