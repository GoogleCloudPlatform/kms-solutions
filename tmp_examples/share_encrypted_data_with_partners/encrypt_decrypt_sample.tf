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

/**
* The resources in this file provide a usage example of
* Cloud KMS-based encryption and decryption, using sample python scripts.
*/

resource "null_resource" "install_python_deps" {

  provisioner "local-exec" {
    command = <<EOF
    python -m venv ./venv &&
    . ./venv/bin/activate &&
    pip install -r ../../share-encrypted-data-with-partners/examples/python/requirements.txt
    EOF
  }
}

resource "null_resource" "encrypt_using_python_example" {

  provisioner "local-exec" {
    command = <<EOF
    ./venv/bin/python ../../share-encrypted-data-with-partners/examples/python/encrypt.py \
    --data_encryption_key_path ./testing_only_dek.bin.index \
    --data "a secret message to be shared" \
    --aad "pre-determined authenticated but unencrypted data" \
    --json > test.json
    EOF
  }

  depends_on = [null_resource.install_python_deps]
}

resource "null_resource" "decrypt_using_python_example" {

  provisioner "local-exec" {
    command = <<EOF
    ./venv/bin/python ../../share-encrypted-data-with-partners/examples/python/decrypt.py \
    --gcp_project ${var.project_id} \
    --gcp_location us-central1 \
    --gcp_keyring ${module.consumer_bootstrap.keyring} \
    --gcp_key ${module.consumer_bootstrap.key} \
    --iv "" --aad "" --ciphertext "" \
    --json_file "./test.json" > decrypted_text.txt
    EOF
  }

  depends_on = [module.consumer_key_import, null_resource.encrypt_using_python_example, null_resource.install_python_deps]
}
