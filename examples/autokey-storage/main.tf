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

# 0-setup module will create the basic resources for Autokey to work.
module "autokey_setup" {
  source = "../../autokey-blueprints/0-setup"

  autokey_parent  = "folders/${var.folder_id}"
  billing_account = var.billing_account
}

# 1-storage-bucket module will create the basic resources for a Storage bucket and configure
# a KMS Autokey key to encrypt data on rest.
module "autokey_storage" {
  source = "../../autokey-blueprints/1-storage-bucket"

  billing_account        = var.billing_account
  autokey_folder_id      = module.autokey_setup.autokey_folder_id
  autokey_key_project_id = module.autokey_setup.autokey_key_project_id
  suffix                 = module.autokey_setup.random_suffix
}
