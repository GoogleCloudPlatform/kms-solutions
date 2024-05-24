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

output "keyring" {
  description = "Name of the keyring."
  value       = module.bootstrap-kms-hsm.keyring
}

output "location" {
  description = "Location of the keyring created."
  value       = module.bootstrap-kms-hsm.location
}

output "key" {
  description = "Name of the key created."
  value       = module.bootstrap-kms-hsm.key
}

output "project_id" {
  description = "ID of the GCP project being used."
  value       = module.bootstrap-kms-hsm.project_id
}

output "vm_hostname" {
  description = "Name of the hostname created."
  value       = module.bootstrap-kms-hsm.vm_hostname
}

output "service_account_email" {
  description = "Service Account created and managed by Terraform."
  value       = module.bootstrap-kms-hsm.service_account_email
}
