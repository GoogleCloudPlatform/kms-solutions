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


variable "data_encryption_key_path" {
  description = "Path to the key used to encrypt data itself (DEK). A random key can be generated with OpenSSL, see step 1 on README. Use the random key for testing only. A the random key created this way is not appropriate for production use, use your company's approved method to generate a data encryption key in a secure environment instead."
  type        = string
}

variable "wrapped_key_path" {
  description = "Path to where the wrapped key file should be created."
  type        = string
}

variable "key_encryption_key_path" {
  description = "Path to where the KEK (Key Encryption Key) is stored. This is usually a public key file extracted from an Import Job received from consumer."
  type        = string
}
