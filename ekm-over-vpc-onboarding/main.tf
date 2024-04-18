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

module "create_vpc_kms_project" {
  source = "./modules/create_vpc_kms_project"

  organization_id              = var.organization_id
  folder_id                    = var.folder_id
  kms_project_name             = var.kms_project_name
  kms_project_id               = var.kms_project_id
  vpc_project_name             = var.vpc_project_name
  vpc_project_id               = var.vpc_project_id
  billing_account              = var.billing_account
  project_creator_member_email = var.project_creator_member_email
  create_kms_project           = var.create_kms_project
  create_vpc_project           = var.create_vpc_project
  random_project_suffix        = var.random_project_suffix
}

module "ekm_resources" {
  source = "./modules/ekm_resources_creation"

  kms_project_id               = module.create_vpc_kms_project.kms_project_id
  vpc_project_id               = module.create_vpc_kms_project.vpc_project_id
  location                     = var.location
  subnet_ip_cidr_range         = var.subnet_ip_cidr_range
  external_key_manager_ip      = var.external_key_manager_ip
  external_key_manager_port    = var.external_key_manager_port
  external_provider_hostname   = var.external_provider_hostname
  external_provider_raw_der    = var.external_provider_raw_der
  crypto_space_path            = var.crypto_space_path
  network_name                 = var.network_name
  servicedirectory_name        = var.servicedirectory_name
  kms_name_prefix              = var.kms_name_prefix
  ekmconnection_name           = var.ekmconnection_name
  key_management_mode          = var.key_management_mode
  project_creator_member_email = var.project_creator_member_email
  ekm_connection_key_path      = var.ekm_connection_key_path

  depends_on = [module.create_vpc_kms_project]
}
