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

  # TODO: Use the Terraform Google KMS module as soon as it supports this field.
  key_access_justifications_policy {
    allowed_access_reasons = sort(var.cryptokey_allowed_access_reasons)
  }

  depends_on = [google_assured_workloads_workload.primary]
}
