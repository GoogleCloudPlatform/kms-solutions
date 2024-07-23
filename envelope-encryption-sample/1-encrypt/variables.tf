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

variable "project_id" {
  description = "GCP project ID to use for the creation of resources."
  type        = string
}

variable "location" {
  description = "Location for the resources (keyring, key, network, etc.)."
  type        = string
  default     = "us-central1"
}

variable "keyring_name" {
  description = "Keyring name."
  type        = string
}

variable "kek_name" {
  description = "Key encryption key name."
  type        = string
}

variable "cli_path" {
  description = "CLI base path."
  default     = "../python-cli"
}

variable "wrapped_key_path" {
  description = "Wrapped Data Encryption Key file."
  type        = string
  default     = "../wrapped_dek"
}

variable "input_file_path" {
  description = "Sensitive file to be encrypted."
  type        = string
}

variable "output_file_path" {
  description = "Encrypted file path output."
  type        = string
  default = "../encrypted_file"
}