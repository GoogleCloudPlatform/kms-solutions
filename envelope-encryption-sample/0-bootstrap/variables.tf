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

variable "project_id" {
  description = "GCP project ID to use for the creation of resources."
  type        = string
}

variable "location" {
  description = "Location for the resources (keyring, key, network, etc.)."
  type        = string
  default     = "us-central1"
}

variable "keyring" {
  description = "Keyring name."
  type        = string
}

variable "kek" {
  description = "Key encryption key name."
  type        = string
}

variable "prevent_destroy" {
  description = "Set the prevent_destroy lifecycle attribute on keys."
  type        = bool
}

variable "cli_path" {
  description = "CLI base path."
  default     = "../"
}

variable "wrapped_key_path" {
  description = "Wrapped Data Encryption Key file."
  type        = string
  default     = "../wrapped_dek"
}
