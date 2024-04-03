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
  value       = google_kms_key_ring.keyring.name
}

output "location" {
  description = "Location of the keyring created."
  value       = google_kms_key_ring.keyring.location
}

output "key" {
  description = "Name of the key created."
  value       = "${var.key}-${local.default_suffix}"
}

output "project_id" {
  description = "ID of the GCP project being used."
  value       = google_kms_key_ring.keyring.project
}

output "import_job_id" {
  description = "ID of the Import Job created."
  value       = local.import_job_id
}
