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
  default_suffix = var.suffix != "" ? var.suffix : random_string.suffix.result
  apis_to_enable = [
    "cloudkms.googleapis.com"
  ]
  kek_name     = keys(module.kms.keys)[0]
  keyring_name = module.kms.keyring_resource.name
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_project_service" "apis_to_enable" {
  for_each = toset(local.apis_to_enable)

  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}

resource "time_sleep" "enable_projects_apis_sleep" {
  create_duration = "30s"

  depends_on = [google_project_service.apis_to_enable]
}

module "kms" {
  source  = "terraform-google-modules/kms/google"
  version = "2.3.0"

  keyring         = "${var.keyring_name}-${local.default_suffix}"
  location        = var.location
  project_id      = var.project_id
  keys            = ["${var.kek_name}-${local.default_suffix}"]
  prevent_destroy = var.prevent_destroy

  depends_on = [time_sleep.enable_projects_apis_sleep]
}

resource "null_resource" "install_python_deps" {

  provisioner "local-exec" {
    command = <<EOF
    python -m venv ./venv &&
    . ./venv/bin/activate &&
    pip install -r ${var.cli_path}/requirements.txt
    EOF
  }
}

resource "null_resource" "generate_data_encryption_key" {

  triggers = {
    project_id = var.project_id
  }

  provisioner "local-exec" {
    when    = create
    command = <<EOF
        ./venv/bin/python ${var.cli_path}/cli.py \
        --mode generate \
        --project_id ${var.project_id} \
        --kek_name ${local.kek_name} \
        --keyring_name ${local.keyring_name} \
        --location ${var.location} \
        --wrapped_key_path ${var.wrapped_key_path}
    EOF
  }

  depends_on = [module.kms, null_resource.install_python_deps]

}
