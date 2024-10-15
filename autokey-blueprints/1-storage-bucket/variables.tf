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

variable "autokey_folder_id" {
  description = "Autokey folder ID to be created or used."
  type        = string
}

variable "autokey_key_project_id" {
  description = "GCP project ID to be used for KMS Autokey keys."
  type        = string
}

variable "autokey_handle_name" {
  description = "Autokey Ken Handle name."
  type        = string
  default     = "key-handle-storage-bucket"
}

variable "location" {
  description = "Location to create the resources."
  type        = string
  default     = "us-central1"
}

variable "bucket_name" {
  description = "Name of the bucket to be created."
  type        = string
  default     = "autokey-bucket-example"
}

variable "create_autokey_resource_project" {
  description = "A new GCP project will be created for the resouce using Autokey if true."
  type        = bool
  default     = true
}

variable "autokey_resource_project_id" {
  description = "GCP project ID to be created or used for the resource using KMS Autokey."
  type        = string
  default     = "autokey-res-project-id"
}

variable "autokey_resource_project_name" {
  description = "GCP project name to be used for the resource using KMS Autokey. Used only when create_autokey_resource_project is true."
  type        = string
  default     = "autokey-res-project-name"
}

variable "billing_account" {
  description = "The ID of the billing account to associate projects with."
  type        = string
}

variable "deletion_policy" {
  description = "The deletion policy for the project."
  type        = string
  default     = "DELETE"
}
