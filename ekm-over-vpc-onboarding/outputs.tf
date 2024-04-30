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

output "kms_project_id" {
  description = "ID of the KMS project"
  value       = module.create_vpc_kms_project.kms_project_id
}

output "vpc_project_id" {
  description = "ID of the VPC project"
  value       = module.create_vpc_kms_project.vpc_project_id
}

output "keyring" {
  description = "Name of the keyring."
  value       = module.ekm_resources.keyring
}

output "crypto_key" {
  description = "Name of the crypto key created."
  value       = module.ekm_resources.crypto_key
}

output "key_version" {
  description = "Name of the key version created."
  value       = module.ekm_resources.key_version
}

output "location" {
  description = "Location of the keyring created."
  value       = module.ekm_resources.location
}

output "ekm_connection_id" {
  description = "ID of the EKM connection created."
  value       = module.ekm_resources.ekm_connection_id
}
