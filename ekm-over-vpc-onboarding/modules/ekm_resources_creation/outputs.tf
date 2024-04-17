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
  value       = google_kms_key_ring.vpc_kms_ring.name
}

output "crypto_key" {
  description = "Name of the crypto key created."
  value       = google_kms_crypto_key.vpc_key.name
}

output "key_version" {
  description = "Name of the key version created."
  value       = google_kms_crypto_key_version.vpc_crypto_key_version.name
}

output "location" {
  description = "Location of the keyring created."
  value       = google_kms_key_ring.vpc_kms_ring.location
}

output "ekm_connection_id" {
  description = "ID of the EKM connection created."
  value       = google_kms_ekm_connection.ekm_main_resource.id
}
