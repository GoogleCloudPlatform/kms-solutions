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

resource "null_resource" "re_enable_cloud_build" {
  provisioner "local-exec" {
    when    = create
    command = "gcloud services enable cloudbuild.googleapis.com --project ${var.project_id} && sleep 30"
  }
}

module "bootstrap-kms-hsm" {
  source = "../common/modules/bootstrap-kms-hsm"

  project_id            = var.project_id
  keyring               = var.keyring
  key                   = var.key
  location              = var.location
  prevent_destroy       = var.prevent_destroy
  suffix                = var.suffix
  artifact_image        = var.artifact_image
  artifact_location     = var.artifact_location
  artifact_repository   = var.artifact_repository
  artifact_version      = var.artifact_version
  hostname              = var.hostname
  organization_id       = var.organization_id
  pkcs11_lib_version    = var.pkcs11_lib_version
  certificate_file_path = var.certificate_file_path
  digest_flag           = var.digest_flag
  certificate_name      = var.certificate_name
  docker_file_path      = var.docker_file_path
}
