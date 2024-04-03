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
  import_job_id = "import-job-${local.default_suffix}"
}

// Create the import job into cloud KMS
resource "null_resource" "gcloud-import-job-creation" {

  provisioner "local-exec" {
    command = "gcloud kms import-jobs create ${local.import_job_id} --location ${var.location} --keyring ${google_kms_key_ring.keyring.name} --import-method ${var.import_job_method} --protection-level hsm  --project ${var.project_id}"
  }

  depends_on = [google_kms_key_ring.keyring]
}

// Retrieve the wrapping (public) key of the import job from cloud KMS
resource "null_resource" "extract-pem-from-import-job" {

  provisioner "local-exec" {
    command = "gcloud kms import-jobs describe ${local.import_job_id} --project=${var.project_id} --location=${var.location} --keyring=${google_kms_key_ring.keyring.name} --format=\"value(publicKey.pem)\" > ${var.import_job_public_key_path}"
  }

  depends_on = [null_resource.gcloud-import-job-creation]
}
