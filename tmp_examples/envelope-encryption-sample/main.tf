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

// Creates all the GCP KMS required infra and a encrypted DEK.
module "bootstrap" {
  source = "../../envelope-encryption-sample/0-bootstrap"

  project_id       = var.project_id
  keyring_name     = "sample-envelope-keyring"
  kek_name         = "sample-envelope-kek"
  wrapped_key_path = "./wrapped_dek"
  prevent_destroy  = false
  cli_path         = var.cli_path
}

// Envelope encrypt a file sample.
module "encrypt" {
  source = "../../envelope-encryption-sample/1-encrypt"

  keyring_name     = module.bootstrap.keyring
  kek_name         = module.bootstrap.kek
  wrapped_key_path = "./wrapped_dek"
  input_file_path  = "./secret_file_sample.txt"
  output_file_path = "./encrypted_file"
  project_id       = var.project_id
  cli_path         = var.cli_path

  depends_on = [module.bootstrap]
}

// Envelope decrypt a file sample.
module "decrypt" {
  source = "../../envelope-encryption-sample/2-decrypt"

  keyring_name     = module.bootstrap.keyring
  kek_name         = module.bootstrap.kek
  wrapped_key_path = "./wrapped_dek"
  input_file_path  = "./encrypted_file"
  output_file_path = "./decrypted_file"
  project_id       = var.project_id
  cli_path         = var.cli_path

  depends_on = [module.encrypt]
}
