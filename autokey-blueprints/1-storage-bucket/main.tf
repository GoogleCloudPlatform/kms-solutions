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
  default_suffix              = var.suffix != "" ? var.suffix : random_string.suffix.result
  autokey_resource_project_id = var.create_autokey_resource_project ? module.autokey_resource_project[0].project_id : var.autokey_resource_project_id
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

module "autokey" {
  source  = "terraform-google-modules/kms/google//modules/autokey"
  version = "3.2.0"

  project_id            = var.autokey_key_project_id
  autokey_folder_number = var.autokey_folder_id

  autokey_handles = {
    storage_bucket = {
      name                   = var.autokey_handle_name,
      project                = local.autokey_resource_project_id,
      resource_type_selector = "storage.googleapis.com/Bucket",
      location               = var.location
    }
  }
}

module "autokey_resource_project" {
  count = var.create_autokey_resource_project ? 1 : 0

  source  = "terraform-google-modules/project-factory/google"
  version = "~> 17.0"

  project_id      = "${var.autokey_resource_project_id}-${local.default_suffix}"
  folder_id       = var.autokey_folder_id
  deletion_policy = var.deletion_policy

  name            = var.autokey_resource_project_name
  billing_account = var.billing_account

  activate_apis = ["storage.googleapis.com"]
}

module "bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "8.0"

  name       = "${var.bucket_name}-${local.default_suffix}"
  project_id = local.autokey_resource_project_id
  location   = var.location
  encryption = {
    default_kms_key_name = module.autokey.autokey_keyhandles["storage_bucket"].kms_key
  }

  depends_on = [module.autokey_resource_project]
}
