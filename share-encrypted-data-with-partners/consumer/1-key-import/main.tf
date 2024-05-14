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

data "terraform_remote_state" "bootstrap" {
  backend = "local"

  config = {
    path = var.bootstrap_state_file_path
  }
}

locals {
  project_id    = data.terraform_remote_state.bootstrap.outputs.project_id
  import_job_id = data.terraform_remote_state.bootstrap.outputs.import_job_id
  keyring       = data.terraform_remote_state.bootstrap.outputs.keyring
  key           = data.terraform_remote_state.bootstrap.outputs.key
  location      = data.terraform_remote_state.bootstrap.outputs.location
}


// Import wrapped key into the existing import job in Cloud KMS
resource "null_resource" "gcloud-import-wrapped-key-into-an-existing-job" {

  provisioner "local-exec" {
    command = "gcloud kms keys versions import --import-job ${local.import_job_id} --location ${local.location} --keyring ${local.keyring} --key ${local.key} --algorithm ${var.crypto_key_algorithm_import} --wrapped-key-file ${var.wrapped_key_path} --project ${local.project_id}"
  }
}
