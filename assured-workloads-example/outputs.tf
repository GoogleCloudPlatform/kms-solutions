/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "aw_id" {
  description = "Assured Workload ID."
  value       = google_assured_workloads_workload.primary.id
}

output "aw_name" {
  description = "Assured Workload name."
  value       = google_assured_workloads_workload.primary.name
}

output "aw_provisioned_resources_parent" {
  description = "Parent of the Assured Workload."
  value       = google_assured_workloads_workload.primary.provisioned_resources_parent
}

output "aw_kaj_enrollment_state" {
  description = "Key Access Justification Enrollment State."
  value       = google_assured_workloads_workload.primary.kaj_enrollment_state
}

output "aw_resources" {
  description = "Resources of the Assured Workload."
  value       = google_assured_workloads_workload.primary.resources
}

output "aw_resource_settings" {
  description = "Resource settings of the Assured Workload."
  value       = google_assured_workloads_workload.primary.resource_settings
}

output "kms_key_id" {
  description = "Crypto Key ID."
  value       = google_kms_crypto_key.hsm_encrypt_decrypt.id
}
