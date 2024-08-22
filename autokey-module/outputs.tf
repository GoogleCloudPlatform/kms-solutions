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

output "autokey_project_id" {
  description = "GCP project ID created for KMS Autokey."
  value       = var.create_autokey_project ? local.autokey_project_id : var.autokey_project_id
}

output "autokey_folder" {
  description = "The Autokey folder created."
  value       = var.create_autokey_folder ? google_folder.autokms_folder[0].folder_id : var.autokey_folder
}

output "autokey_config" {
  description = "A Autokey identifier."
  value       = google_kms_autokey_config.autokeyconfig.id
}
