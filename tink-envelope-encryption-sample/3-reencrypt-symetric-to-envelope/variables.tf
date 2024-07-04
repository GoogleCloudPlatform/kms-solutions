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

variable "tink_sa_credentials_file" {
  description = "Service accounts credential file path required by Tink."
  type        = string
}

variable "rotate_encrypted_file_path" {
  description = "Path to the encrypted file to be used to envelope encryption on rotation."
  type        = string
  default     = "./file_to_be_envelope_encrypted"
}

variable "current_encrypted_file_path" {
  description = "Path to the symetric encrypted file to be used."
  type        = string
}

variable "cli_path" {
  description = "CLI base path."
  default     = "../"
}

variable "associated_data" {
  description = "The associated data in Authenticated Encryption with Associated Data (AEAD) is used to tie ciphertext to specific associated data. Associated data is authenticated but NOT encrypted."
  default     = "associated_data_sample"
}

variable "tink_keyset_file" {
  description = "Tink keyset file name."
  type        = string
}

variable "kek_uri" {
  description = "KMS Key Encryption Key (KEK) URI."
  type        = string
}

variable "current_project_id" {
  description = "GCP project ID of the KMS used to symetric encryption."
  type        = string
}

variable "location" {
  description = "Location for the resources used to symetric encryption."
  type        = string
  default     = "us-central1"
}

variable "current_keyring" {
  description = "Keyring name used to symetric encryption."
  type        = string
}

variable "current_key" {
  description = "Key encryption name used to symetric encryption."
  type        = string
}

variable "encrypted_file_path" {
  description = "Path to the encrypted file to be output by terraform."
  type        = string
  default     = "./envelope_encrypted_file"
}
