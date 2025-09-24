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

// This file provides all the required resources to demonstrate a encryption key changing from a symmetric encryption to envelope encryption.

module "symmetric_kms" {
  source  = "terraform-google-modules/kms/google"
  version = "4.1.0"

  keyring         = local.keyring
  location        = local.location
  project_id      = var.project_id
  keys            = [local.key]
  prevent_destroy = false
}

resource "null_resource" "encrypt_symmetric" {

  provisioner "local-exec" {
    when    = create
    command = <<EOF
      gcloud kms encrypt \
      --key ${local.key} \
      --keyring ${local.keyring}  \
      --location ${local.location}  \
      --ciphertext-file ./symmetric_encrypted_file \
      --plaintext-file ./secret_file_sample.txt \
      --project ${var.project_id}
    EOF
  }

  depends_on = [module.symmetric_kms]
}
