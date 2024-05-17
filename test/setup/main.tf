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

module "project_ci_kms" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 15.0"

  name              = "ci-kms-module"
  random_project_id = "true"
  org_id            = var.org_id
  folder_id         = var.folder_id
  billing_account   = var.billing_account

  activate_apis = [
    "cloudkms.googleapis.com",
    "serviceusage.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com"
  ]

  activate_api_identities = [
    {
      api   = "cloudbuild.googleapis.com",
      roles = ["roles/cloudbuild.builds.builder"]
    }
  ]
}

data "google_client_config" "default" {}

resource "terracurl_request" "poke" {
  name   = "poke-cb"
  url    = "https://cloudbuild.googleapis.com/v1/projects/${module.project_ci_kms.project_id}/locations/us-central1/builds"
  method = "POST"
  headers = {
    Authorization = "Bearer ${data.google_client_config.default.access_token}"
    Content-Type  = "application/json",
  }
  response_codes = [400]
  depends_on = [
    module.project_ci_kms
  ]
  lifecycle {
    ignore_changes = [
      headers,
    ]
  }
}
