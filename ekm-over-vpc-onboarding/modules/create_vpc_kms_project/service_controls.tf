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
  create_vpc_sc_resources          = var.enable_vpc_sc && var.create_kms_project && var.create_vpc_project
  access_context_manager_policy_id = var.access_context_manager_policy_id != "" ? var.access_context_manager_policy_id : module.access_context_manager_policy.policy_id
  restricted_services              = distinct(concat(local.apis_to_activate_in_kms_project, local.apis_to_activate_in_vpc_project))
}

module "access_context_manager_policy" {
  count = local.create_vpc_sc_resources && var.access_context_manager_policy_id == "" ? 1 : 0

  source  = "terraform-google-modules/vpc-service-controls/google"
  version = "~> 6.0"

  parent_id   = var.organization_id
  policy_name = "default policy"
}

module "access_level_members" {
  count   = local.create_vpc_sc_resources ? 1 : 0
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "~> 6.0"

  policy  = local.access_context_manager_policy_id
  name    = var.access_level_members_name
  members = var.access_level_members
}

module "regular_service_perimeter_dry_run" {
  count   = local.create_vpc_sc_resources ? 1 : 0
  source  = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version = "~> 6.0"

  policy                      = var.access_context_manager_policy_id
  perimeter_name              = var.perimeter_name
  description                 = "EKM Perimeter shielding projects"
  access_levels               = [module.access_level_members[0].name]
  restricted_services_dry_run = local.restricted_services
  resources_dry_run           = [module.vpc_project[0].project_number, module.kms_project[0].project_number]
}
