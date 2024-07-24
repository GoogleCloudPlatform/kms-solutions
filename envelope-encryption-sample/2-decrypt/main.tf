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

resource "null_resource" "install_python_deps" {

  provisioner "local-exec" {
    command = <<EOF
    python -m venv ./venv &&
    . ./venv/bin/activate &&
    pip install -r ${var.cli_path}/requirements.txt
    EOF
  }
}

resource "null_resource" "decrypt_file" {

  triggers = {
    project_id = var.project_id
  }

  provisioner "local-exec" {
    when    = create
    command = <<EOF
        ./venv/bin/python ${var.cli_path}/cli.py \
        --mode decrypt \
        --project_id ${var.project_id} \
        --kek_name ${var.kek_name} \
        --keyring_name ${var.keyring_name} \
        --location ${var.location} \
        --wrapped_key_path ${var.wrapped_key_path} \
        --input ${var.input_file_path} \
        --output ${var.output_file_path}
    EOF
  }

  depends_on = [null_resource.install_python_deps]

}
