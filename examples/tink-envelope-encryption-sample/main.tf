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
  key              = "old-key"
  keyring          = "old-keyring"
  location         = "us-central1"
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
  tink_sa_credentials_file = local_file.temp_sa_key_file
  cli_path                 = var.cli_path
}

// Change the encryption from symetric to envelope.
module "reencrypt_symetric_to_envelope" {
  source = "../../tink-envelope-encryption-sample/3-reencrypt-symetric-to-envelope"

  current_keyring             = local.keyring
  current_key                 = local.key
  current_encrypted_file_path = "./symetric_encrypted_file"
  current_project_id          = var.project_id
  kek_uri                     = module.bootstrap.kek_uri
  tink_keyset_file            = module.bootstrap.tink_keyset_file
  tink_sa_credentials_file    = local.temp_sa_key_file
  cli_path                    = var.cli_path

  # depends_on = [local_file.temp_sa_key_file, null_resource.encrypt_symetric, module.symetric_kms]
  depends_on = [null_resource.encrypt_symetric, module.symetric_kms]
}

// Decrypt the enveloped encrypted file.
module "decrypt_enveloped_file" {
  source = "../../tink-envelope-encryption-sample/2-decrypt"

  kek_uri                  = module.bootstrap.kek_uri
  tink_sa_credentials_file = local.temp_sa_key_file
  encrypted_file_path      = "./envelope_encrypted_file"
  tink_keyset_file         = module.bootstrap.tink_keyset_file
}
