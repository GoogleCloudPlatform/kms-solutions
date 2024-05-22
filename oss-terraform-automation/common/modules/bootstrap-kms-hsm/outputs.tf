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
  description = "Name of the keyring created."
  value       = module.kms.keyring_resource.name
}

output "location" {
  description = "Location of the keyring."
  value       = module.kms.keyring_resource.location
}

output "key" {
  description = "Name of the key created."
  value       = keys(module.kms.keys)[0]
}

output "project_id" {
  description = "ID of the GCP project being used."
  value       = module.kms.keyring_resource.project
}

output "suffix" {
  description = "A suffix used as an identifier for resources. (e.g., suffix for KMS Key, Keyring, SAs, etc.)"
  value       = local.default_suffix
}

output "custom_service_account_email" {
  description = "Service Account created and managed by Terraform used to trigger Cloud Build jobs."
  value       = google_service_account.custom_sa.email
}

output "artifact_registry_repository_name" {
  description = "Name of the Artifact Registry repository created."
  value       = google_artifact_registry_repository.pkcs11_hsm_examples.name
}

output "vm_hostname" {
  description = "Name of the hostname created."
  value       = var.hostname
}
