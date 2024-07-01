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

module "tink_encrypt" {
  source = "../../tink-envelope-encryption-sample/0-encrypt"

  project_id               = var.project_id
  keyring                  = "simple-example-keyring"
  kek                      = "simple-example-key"
  input_file_path          = "./secret_file_sample.txt"
  tink_sa_credentials_file = local.temp_sa_key_file
  prevent_destroy          = false
  cli_path                 = var.cli_path

  depends_on = [local_file.temp_sa_key_file]
}

module "tink_decrypt" {
  source = "../../tink-envelope-encryption-sample/1-decrypt"

  tink_keyset_file         = module.tink_encrypt.tink_keyset_file
  tink_kek_uri             = module.tink_encrypt.kek_key_uri
  encrypted_file_path      = module.tink_encrypt.encrypted_file_path
  tink_sa_credentials_file = local.temp_sa_key_file
  cli_path                 = var.cli_path

  depends_on = [module.tink_encrypt]
}
