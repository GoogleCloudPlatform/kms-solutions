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

# Grants appropriate permissions to the projects
resource "google_project_iam_member" "iam_member_roles_kms" {
  for_each = toset([
    "roles/cloudkms.admin"
  ])
  role    = each.key
  member  = format("user:%s", var.project_creator_member_email == "" ? data.google_client_openid_userinfo.provider_identity.email : var.project_creator_member_email)
  project = data.google_project.kms_project.number
}
resource "google_project_iam_member" "iam_member_roles_vpc" {
  for_each = toset([
    "roles/compute.networkAdmin",
    "roles/compute.securityAdmin",
    "roles/servicedirectory.admin",
  ])
  role    = each.key
  member  = format("user:%s", var.project_creator_member_email == "" ? data.google_client_openid_userinfo.provider_identity.email : var.project_creator_member_email)
  project = data.google_project.vpc_project.number
}

#Granting appropriate roles to service account
resource "google_project_iam_member" "sd_iam_member_roles" {
  for_each = toset([
    "roles/servicedirectory.pscAuthorizedService",
    "roles/servicedirectory.viewer",
    "roles/servicedirectory.networkAttacher",
  ])
  role    = each.key
  member  = "serviceAccount:service-${data.google_project.kms_project.number}@gcp-sa-ekms.iam.gserviceaccount.com"
  project = data.google_project.vpc_project.number

  depends_on = [google_project_service_identity.enable_ekm_service_agent]
}
