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

variable "tink_keyset_file" {
  description = "Tink keyset file name."
  type        = string
}

variable "tink_sa_credentials_file" {
  description = "Service accounts credential file path required by Tink."
  type        = string
}

variable "tink_kek_uri" {
  description = "Key encryption key (KEK) URI."
  type        = string
}

variable "encrypted_file_path" {
  description = "Path to the encrypted file."
  type        = string
}

variable "decrypted_file_path" {
  description = "Path to the decrypted file to be output by terraform."
  type        = string
  default     = "./decrypted_file"
}

variable "python_venv_path" {
  description = "Python virtual environment path to be created."
  default     = "../decrypt_venv"
}

variable "python_cli_path" {
  description = "Python CLI base path."
  default     = ".."
}
