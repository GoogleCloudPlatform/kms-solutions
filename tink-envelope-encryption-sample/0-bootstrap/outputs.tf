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

output "kek_uri" {
  description = "KMS Key Encryption Key (KEK) URI."
  value       = "gcp-kms://projects/${var.project_id}/locations/${var.location}/keyRings/${module.kms.keyring_resource.name}/cryptoKeys/${keys(module.kms.keys)[0]}"
}

output "keyring" {
  description = "Name of the keyring."
  value       = module.kms.keyring_name
}

output "key" {
  description = "Name of the key created."
  value       = keys(module.kms.keys)[0]
}

output "tink_keyset_file" {
  description = "Name of tink keyset file created."
  value       = local.tink_keyset_file
}
