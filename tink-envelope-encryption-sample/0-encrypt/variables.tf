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

variable "tink_keyset_output_file" {
  description = "Tink keyset output file name."
  type        = string
  default     = "./encrypted_keyset"
}

variable "tink_sa_credentials_file" {
  description = "Service accounts credential file path required by Tink."
  type        = string
}

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

variable "input_file_path" {
  description = "Path to the input file to be encrypted."
  type        = string
}

variable "encrypted_file_path" {
  description = "Path to the encrypted file to be output by terraform."
  type        = string
  default     = "./encrypted_file"
}

variable "python_venv_path" {
  description = "Python virtual environment path to be created."
  default     = "../encrypt_venv"
}

variable "python_cli_path" {
  description = "Python CLI base path."
  default     = ".."
}
