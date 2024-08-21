/**
 * Copyright 2018 Google LLC
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
  int_required_roles = [
    "roles/cloudkms.admin",
    "roles/iam.serviceAccountTokenCreator",
    "roles/iam.serviceAccountUser",

    # Needed to run verifications:
    "roles/owner"
  ]

  int_org_required_roles = [
    "roles/resourcemanager.projectCreator",
    "roles/resourcemanager.folderCreator"
  ]
}

resource "google_service_account" "int_test" {
  project      = module.project_ci_kms.project_id
  account_id   = "kms-int-test"
  display_name = "kms-int-test"
}

resource "google_organization_iam_member" "org_admins_group" {
  for_each = toset(local.int_org_required_roles)
  org_id   = var.org_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_project_iam_member" "int_test" {
  for_each = toset(local.int_required_roles)

  project = module.project_ci_kms.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_service_account_key" "int_test" {
  service_account_id = google_service_account.int_test.id
}

resource "google_project_service_identity" "cb_sa" {
  provider = google-beta

  project = module.project_ci_kms.project_id
  service = "cloudbuild.googleapis.com"
}
