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

// Wrapping a DEK (Data Encryption Key) using OpenSSL. See more in: https://cloud.google.com/kms/docs/wrapping-a-key#wrap_key
resource "null_resource" "openssl-dek-wrap-process" {

  provisioner "local-exec" {
    command = "openssl pkeyutl -encrypt -pubin -inkey ${var.key_encryption_key_path} -in ${var.data_encryption_key_path} -out ${var.wrapped_key_path} -pkeyopt rsa_padding_mode:oaep -pkeyopt rsa_oaep_md:sha256 -pkeyopt rsa_mgf1_md:sha256"
  }
}
