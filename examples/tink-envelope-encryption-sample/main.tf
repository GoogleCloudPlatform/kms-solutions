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

locals {
  temp_sa_key_file = "./sa_key.tmp"
}

resource "local_file" "temp_sa_key_file" {
  content  = base64decode(var.sa_key)
  filename = local.temp_sa_key_file
}

// Creates all the GCP KMS required infra and a Tink encrypted keyset.
module "bootstrap" {
  source = "../../tink-envelope-encryption-sample/0-bootstrap"

  project_id               = var.project_id
  keyring                  = "sample-envelope-keyring"
  kek                      = "sample-envelope-kek"
  prevent_destroy          = false
  tink_sa_credentials_file = local.temp_sa_key_file
  cli_path                 = var.cli_path
  tink_keyset_output_file  = "./encrypted_keyset"
}

// Envelope encrypt the file.
module "envelope_encrypt_file" {
  source = "../../tink-envelope-encryption-sample/1-encrypt"

  input_file_path          = "./secret_file_sample.txt"
  kek_uri                  = module.bootstrap.kek_uri
  tink_keyset_file         = module.bootstrap.tink_keyset_file
  tink_sa_credentials_file = local.temp_sa_key_file
  cli_path                 = var.cli_path

  depends_on = [local_file.temp_sa_key_file, module.bootstrap]
}

// Decrypt the enveloped encrypted file.
module "decrypt_enveloped_file" {
  source = "../../tink-envelope-encryption-sample/2-decrypt"

  kek_uri                  = module.bootstrap.kek_uri
  tink_sa_credentials_file = local.temp_sa_key_file
  encrypted_file_path      = "./envelope_encrypted_file"
  tink_keyset_file         = module.bootstrap.tink_keyset_file

  depends_on = [module.envelope_encrypt_file]
}
