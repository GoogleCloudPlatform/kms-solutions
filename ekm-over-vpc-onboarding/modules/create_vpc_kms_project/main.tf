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

#####
# Script to create project
#####

locals {
  apis_to_activate_in_kms_project = [
    "compute.googleapis.com",
    "cloudkms.googleapis.com",
    "servicedirectory.googleapis.com",
  ]

  apis_to_activate_in_vpc_project = [
    "compute.googleapis.com",
    "servicedirectory.googleapis.com",
  ]

}

# Create KMS and VPC projects if specified
module "kms_project" {
  count = var.create_kms_project ? 1 : 0

  source  = "terraform-google-modules/project-factory/google"
  version = "~> 17.0"

  project_id                  = var.kms_project_id
  random_project_id           = var.random_project_suffix
  disable_services_on_destroy = true
  org_id                      = var.organization_id
  folder_id                   = var.folder_id
  name                        = var.kms_project_name
  billing_account             = var.billing_account
  activate_apis               = local.apis_to_activate_in_kms_project
}

module "vpc_project" {
  count = var.create_vpc_project ? 1 : 0

  source  = "terraform-google-modules/project-factory/google"
  version = "~> 17.0"

  project_id                  = var.vpc_project_id
  random_project_id           = var.random_project_suffix
  disable_services_on_destroy = true
  org_id                      = var.organization_id
  folder_id                   = var.folder_id
  name                        = var.vpc_project_name == "" ? var.kms_project_name : var.vpc_project_name
  billing_account             = var.billing_account
  activate_apis               = local.apis_to_activate_in_vpc_project
}

# Enabling APIs when an existing project is provided

resource "google_project_service" "kms_project" {
  for_each = var.create_kms_project ? toset([]) : toset(local.apis_to_activate_in_kms_project)

  project = var.kms_project_id
  service = each.value
}

resource "google_project_service" "vpc_project" {
  for_each = var.create_vpc_project ? toset([]) : toset(local.apis_to_activate_in_vpc_project)

  project = var.vpc_project_id
  service = each.value
}
