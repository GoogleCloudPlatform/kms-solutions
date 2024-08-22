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

variable "suffix" {
  description = "A suffix to be used as an identifier for resources. (e.g., suffix for KMS Key, Keyring, SAs, etc.)."
  type        = string
  default     = ""
}

variable "autokey_parent" {
  description = "The parent of the Autokey folder. It can be an organization or a folder. Format: organization/<org_number> or folders/<folder_number>. Used only when create_autokey_folder is true."
  type        = string
  default     = ""
}

variable "autokey_folder" {
  description = "Autokey folder name to be created or used."
  type        = string
  default     = "folder-autokey"
}

variable "create_autokey_folder" {
  description = "A new GCP folder will be created for Autokey if true."
  type        = bool
  default     = true
}

variable "create_autokey_project" {
  description = "A new GCP project will be created for Autokey if true."
  type        = bool
  default     = true
}

variable "autokey_project_id" {
  description = "GCP project ID to be created or used for KMS Autokey."
  type        = string
  default     = "kms-autokey-project-id"
}

variable "autokey_project_name" {
  description = "GCP project name to be used for KMS project. Used only when create_autokey_project is true."
  type        = string
  default     = "kms-autokey-project-name"
}

variable "billing_account" {
  description = "The ID of the billing account to associate projects with."
  type        = string
}
