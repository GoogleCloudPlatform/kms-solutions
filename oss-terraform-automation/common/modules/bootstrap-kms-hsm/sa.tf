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
  custom_sa       = google_service_account.custom_sa.id
  custom_sa_name  = google_service_account.custom_sa.name
  custom_sa_email = element(split("/", local.custom_sa), length(split("/", local.custom_sa)) - 1)
}

resource "google_service_account" "custom_sa" {
  project      = var.project_id
  account_id   = "tf-custom-sa-${local.default_suffix}"
  display_name = "SA to be used on Cloud Build and Compute Engine. Suffix identifier: ${local.default_suffix}. Managed by Terraform."
}

resource "google_project_iam_member" "cb_sa_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${local.custom_sa_email}"
}

resource "google_project_iam_member" "sa_cloudbuild_builder" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.builder"
  member  = "serviceAccount:${local.custom_sa_email}"
}

resource "google_project_iam_member" "cb_service_agent" {
  project = var.project_id
  role    = "roles/cloudbuild.serviceAgent"
  member  = "serviceAccount:${local.custom_sa_email}"
}

resource "google_kms_crypto_key_iam_member" "crypto_key_role" {
  crypto_key_id = values(module.kms.keys)[0]
  role          = "roles/cloudkms.signerVerifier"
  member        = "serviceAccount:${local.custom_sa_email}"
}

resource "google_kms_key_ring_iam_member" "key_ring_role" {
  key_ring_id = module.kms.keyring
  role        = "roles/cloudkms.viewer"
  member      = "serviceAccount:${local.custom_sa_email}"
}

resource "google_artifact_registry_repository_iam_member" "custom_sa" {
  project    = var.project_id
  location   = var.location
  repository = google_artifact_registry_repository.pkcs11_hsm_examples.name
  role       = "roles/artifactregistry.repoAdmin"
  member     = "serviceAccount:${local.custom_sa_email}"
}

data "google_project" "cloudbuild_project" {
  project_id = var.project_id
}

resource "google_service_account_iam_member" "self_impersonation" {
  service_account_id = local.custom_sa_name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${local.custom_sa_email}"
}

resource "google_service_account_iam_member" "cb_service_agent_impersonate" {
  service_account_id = local.custom_sa_name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:service-${data.google_project.cloudbuild_project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"

  depends_on = [time_sleep.enable_projects_apis_sleep]
}

resource "google_project_iam_member" "sa_service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${local.custom_sa_email}"
}

resource "google_project_iam_member" "sa_compute_admin" {
  project = var.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${local.custom_sa_email}"
}
