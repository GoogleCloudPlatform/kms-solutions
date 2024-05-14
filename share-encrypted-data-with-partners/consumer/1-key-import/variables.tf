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

variable "bootstrap_state_file_path" {
  description = "Path of the 0-bootstrap module state file"
  type        = string
  default     = "../0-bootstrap/terraform.tfstate"
}
