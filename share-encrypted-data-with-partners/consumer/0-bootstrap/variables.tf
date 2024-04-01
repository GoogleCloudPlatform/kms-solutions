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
  description = "A suffix to be used as an identifier for resources. (e.g., suffix for KMS Key, Keyring, SAs, etc.). If not provided, a 4 character random one will be generated."
  type        = string
  default     = ""
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

variable "import_job_public_key_path" {
  description = "Path to import job public key that will be auto-generated. The DEK is encrypted (also known as wrapped) by a key encryption key (KEK) provided by import job."
  type        = string
}

variable "prevent_destroy" {
  description = "Set the prevent_destroy lifecycle attribute on keys."
  type        = bool
  default     = true
}

variable "crypto_key_algorithm_template" {
  description = "Algorithm to use when creating a key template. See more: https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm."
  type        = string
  default     = "AES_256_GCM"
}

variable "import_job_method" {
  description = "Wrapping method to be used for incoming key material. See more: https://cloud.google.com/kms/docs/key-wrapping."
  type        = string
  default     = "rsa-oaep-4096-sha256"
}
