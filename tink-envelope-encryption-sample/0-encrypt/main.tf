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
  tink_kek_uri     = "gcp-kms://projects/${var.project_id}/locations/${var.location}/keyRings/${module.kms.keyring_resource.name}/cryptoKeys/${keys(module.kms.keys)[0]}"
  keyset_file_name = "${var.tink_keyset_output_file}-${local.default_suffix}.json"
}

resource "null_resource" "setup_python" {

  provisioner "local-exec" {
    command = <<EOF
    python -m venv ${var.python_venv_path} &&
    . ${var.python_venv_path}/bin/activate &&
    pip install -r ${var.python_cli_path}/requirements.txt
    EOF
  }
}

resource "null_resource" "tinkey_create_keyset" {

  triggers = {
    project_id              = var.project_id
    tink_keyset_output_file = var.tink_keyset_output_file
  }

  provisioner "local-exec" {
    when    = create
    command = <<EOF
        ${var.python_venv_path}/bin/python ${var.python_cli_path}/encrypted_keyset_cli.py \
        --mode generate \
        --keyset_path ${local.keyset_file_name} \
        --kek_uri ${local.tink_kek_uri} \
        --gcp_credential_path ${var.tink_sa_credentials_file}
    EOF
  }

  depends_on = [module.kms, null_resource.setup_python]
}

resource "null_resource" "tinkey_encrypt" {

  triggers = {
    project_id      = var.project_id
    input_file_path = var.input_file_path
  }

  provisioner "local-exec" {
    when    = create
    command = <<EOF
        ${var.python_venv_path}/bin/python ${var.python_cli_path}/encrypted_keyset_cli.py \
        --mode encrypt \
        --keyset_path ${local.keyset_file_name} \
        --kek_uri ${local.tink_kek_uri} \
        --gcp_credential_path ${var.tink_sa_credentials_file} \
        --input_path ${var.input_file_path} \
        --output_path ${var.encrypted_file_path}
    EOF
  }

  depends_on = [null_resource.tinkey_create_keyset]
}
