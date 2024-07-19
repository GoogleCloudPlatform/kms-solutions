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

# locals {
#   default_suffix = var.suffix != "" ? var.suffix : random_string.suffix.result
#   apis_to_enable = [
#     "cloudkms.googleapis.com"
#   ]
# }

# resource "random_string" "suffix" {
#   length  = 4
#   special = false
#   upper   = false
# }

# resource "google_project_service" "apis_to_enable" {
#   for_each = toset(local.apis_to_enable)

#   project            = var.project_id
#   service            = each.key
#   disable_on_destroy = false
# }

# resource "time_sleep" "enable_projects_apis_sleep" {
#   create_duration = "30s"

#   depends_on = [google_project_service.apis_to_enable]
# }

# module "kms" {
#   source  = "terraform-google-modules/kms/google"
#   version = "2.3.0"

#   keyring         = "${var.keyring}-${local.default_suffix}"
#   location        = var.location
#   project_id      = var.project_id
#   keys            = ["${var.kek}-${local.default_suffix}"]
#   prevent_destroy = var.prevent_destroy

#   depends_on = [time_sleep.enable_projects_apis_sleep]
# }

module "kms" {
  source  = "terraform-google-modules/kms/google"
  version = "2.3.0"

  keyring         = "tf-keyring-example"
  location        = "us-central1"
  project_id      = "envelope-429618"
  keys            = ["envelope1"]
  prevent_destroy = false
}
