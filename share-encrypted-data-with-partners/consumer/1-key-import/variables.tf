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

variable "wrapped_key_path" {
  description = "Path to the wrapped key file."
  type        = string
}

variable "crypto_key_algorithm_import" {
  description = "Algorithm to use when creating a crypto key version through import. See more: https://cloud.google.com/sdk/gcloud/reference/kms/keys/versions/import."
  type        = string
  default     = "aes-256-gcm"
}

variable "project_id" {
  description = "GCP project ID to use for the creation of resources."
  type        = string
}

variable "location" {
  description = "Location for the keyring. For available KMS locations see: https://cloud.google.com/kms/docs/locations."
  type        = string
  default     = "us-central1"
}

variable "keyring" {
  description = "Name of the keyring to be created."
  type        = string
}

variable "key" {
  description = "Name of the key to be created."
  type        = string
}

variable "import_job_id" {
  description = "ID of the import job created in 0-bootstrap module"
  type        = string
}
