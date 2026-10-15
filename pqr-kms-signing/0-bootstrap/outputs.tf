/**
 * Copyright 2026 Google LLC
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

output "key_ring_id" {
  description = "The ID of the created KMS key ring."
  value       = module.kms.keyring
}

output "signing_key_id" {
  description = "The resource ID of the post-quantum signing key."
  value       = module.kms.keys[var.key_name]
}

output "location" {
  description = "The location of the KMS key ring."
  value       = var.location
}

output "keyring_name" {
  description = "The name of the KMS key ring."
  value       = var.keyring_name
}

output "key_name" {
  description = "The name of the post-quantum signing key."
  value       = var.key_name
}

output "kms_key_uri" {
  description = "KMS key URI in tink-go format"
  value       = "gcp-kms://${data.google_kms_crypto_key_version.primary.name}"
}
