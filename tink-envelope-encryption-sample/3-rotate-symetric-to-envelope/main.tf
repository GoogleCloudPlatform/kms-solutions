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

resource "null_resource" "decrypt_current_file" {

  triggers = {
    current_encrypted_file_path = var.current_encrypted_file_path
    rotate_encrypted_file_path = var.rotate_encrypted_file_path
  }

  provisioner "local-exec" {
    when    = create
    command = <<EOF
      gcloud kms decrypt \
      --key ${var.current_key} \
      --keyring ${var.current_keyring} \
      --location ${var.location}  \
      --ciphertext-file ${var.current_encrypted_file_path} \
      --plaintext-file ${var.rotate_encrypted_file_path} \
      --project ${var.current_project_id}
    EOF
  }

}

module "tink_encrypt" {
  source = "../1-encrypt"

  tink_keyset_file = var.tink_keyset_file
  kek_uri = var.kek_uri
  tink_sa_credentials_file = var.tink_sa_credentials_file
  input_file_path = var.rotate_encrypted_file_path

  depends_on = [null_resource.decrypt_current_file]
}
