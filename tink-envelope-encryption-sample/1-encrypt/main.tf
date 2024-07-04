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

resource "null_resource" "tinkey_encrypt" {

  triggers = {
    input_file_path = var.input_file_path
  }

  provisioner "local-exec" {
    when    = create
    command = <<EOF
        go run ${var.cli_path}/encrypted_keyset_cli.go \
        --mode encrypt \
        --keyset_path ${var.tink_keyset_file} \
        --kek_uri ${var.kek_uri} \
        --gcp_credential_path ${var.tink_sa_credentials_file} \
        --input_path ${var.input_file_path} \
        --output_path ${var.encrypted_file_path} \
        --associated_data ${var.associated_data}
    EOF
  }
}
