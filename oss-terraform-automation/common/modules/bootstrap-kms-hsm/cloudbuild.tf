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
  certificate_file_string = var.certificate_file_path != null ? file(var.certificate_file_path) : ""
}

resource "null_resource" "pkcs11_docker_image_build_template" {

  triggers = {
    project_id                = var.project_id
    terraform_service_account = google_service_account.custom_sa.email
  }

  provisioner "local-exec" {
    when    = create
    command = <<EOF
    gcloud builds submit --project=${var.project_id} --config=${path.module}/cloudbuild.yaml --impersonate-service-account=${local.custom_sa_email} --substitutions=_LOCATION="${var.artifact_location}",_REPOSITORY="${var.artifact_repository}-${local.default_suffix}",_IMAGE="${var.artifact_image}",_VERSION="${var.artifact_version}",_KMS_KEYRING="${var.keyring}-${local.default_suffix}",_KMS_KEY="${var.key}-${local.default_suffix}",_KMS_LOCATION="${var.location}",_PKCS11_LIB_VERSION="${var.pkcs11_lib_version}",_SERVICE_ACCOUNT="${local.custom_sa_email}",_CERTIFICATE_FILE="${local.certificate_file_string}",_DIGEST_FLAG="${var.digest_flag}",_CERTIFICATE_NAME="${var.certificate_name}" ${var.docker_file_path} || ( sleep 45 gcloud builds submit --project=${var.project_id} --config=${path.module}/cloudbuild.yaml --impersonate-service-account=${local.custom_sa_email} --substitutions=_LOCATION="${var.artifact_location}",_REPOSITORY="${var.artifact_repository}-${local.default_suffix}",_IMAGE="${var.artifact_image}",_VERSION="${var.artifact_version}",_KMS_KEYRING="${var.keyring}-${local.default_suffix}",_KMS_KEY="${var.key}-${local.default_suffix}",_KMS_LOCATION="${var.location}",_PKCS11_LIB_VERSION="${var.pkcs11_lib_version}",_SERVICE_ACCOUNT="${local.custom_sa_email}",_CERTIFICATE_FILE="${local.certificate_file_string}",_DIGEST_FLAG="${var.digest_flag}",_CERTIFICATE_NAME="${var.certificate_name}" ${var.docker_file_path} )
    EOF
  }

  depends_on = [
    module.kms,
    module.vpc,
    google_artifact_registry_repository.pkcs11_hsm_examples,
    google_project_iam_member.cb_service_agent,
    google_project_iam_member.sa_service_account_user,
    google_service_account_iam_member.cb_service_agent_impersonate,
    google_service_account_iam_member.self_impersonation,
    time_sleep.enable_projects_apis_sleep,
    google_project_iam_member.sa_cloudbuild_builder,
    google_project_iam_member.owner_attempt,
    google_project_iam_member,owner_attempt_2,
    google_project_iam_member.owner_attempt_3,
  ]
}
