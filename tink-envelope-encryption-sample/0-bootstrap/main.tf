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
  tink_kek_uri   = "gcp-kms://projects/${var.project_id}/locations/${var.location}/keyRings/${module.kms.keyring_resource.name}/cryptoKeys/${keys(module.kms.keys)[0]}"
  default_suffix = var.suffix != "" ? var.suffix : random_string.suffix.result
  apis_to_enable = [
    "cloudkms.googleapis.com"
  ]
  tink_keyset_file = "${var.tink_keyset_output_file}-${random_string.suffix.result}.json"
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
  version = "4.0.0"

  keyring         = "${var.keyring}-${local.default_suffix}"
  location        = var.location
  project_id      = var.project_id
  keys            = ["${var.kek}-${local.default_suffix}"]
  prevent_destroy = var.prevent_destroy

  depends_on = [time_sleep.enable_projects_apis_sleep]
}

resource "null_resource" "tinkey_create_keyset" {

  triggers = {
    project_id              = var.project_id
    tink_keyset_output_file = var.tink_keyset_output_file
  }

  provisioner "local-exec" {
    when    = create
    command = <<EOF
        go run ${var.cli_path}/encrypted_keyset_cli.go \
        --mode generate \
        --output_path ${local.tink_keyset_file} \
        --kek_uri ${local.tink_kek_uri} \
        --gcp_credential_path ${var.tink_sa_credentials_file}
    EOF
  }

  depends_on = [module.kms]

}
