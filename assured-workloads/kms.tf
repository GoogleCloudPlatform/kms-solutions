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

resource "google_kms_crypto_key" "hsm_encrypt_decrypt" {
  # TODO: As soon as it supports the "key_access_justifications_policy" field, let's use the "production" provider and the Terraform Google KMS module to create the key.
  provider = google-beta

  name     = "${var.aw_base_id}-encrypt-decrypt-key-${local.default_suffix}"
  key_ring = "projects/${local.encryption_keys_project_id}/locations/${var.aw_location}/keyRings/${local.keyring_id}"

  purpose = "ENCRYPT_DECRYPT"

  version_template {
    algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
    protection_level = "HSM"
  }

  lifecycle {
    prevent_destroy = false
  }

  dynamic "key_access_justifications_policy" {
    for_each = var.cryptokey_allowed_access_reasons == null ? [] : ["1"]
    content {
      allowed_access_reasons = sort(var.cryptokey_allowed_access_reasons)
    }
  }

  depends_on = [google_assured_workloads_workload.primary]
}
