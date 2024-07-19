

resource "google_kms_key_ring" "keyring" {
  name     = "keyring-example"
  location = "global"
  project = "envelope-429618"
}

resource "google_kms_crypto_key" "key1" {
  provider = google-beta

  name     = "crypto-key-example2"
  key_ring = google_kms_key_ring.keyring.id
  purpose  = "ENCRYPT_DECRYPT"

  version_template {
    algorithm = "GOOGLE_SYMMETRIC_ENCRYPTION"
    protection_level = "HSM"
  }

  # key_access_justifications_policy {
  #   allowed_access_reasons = ["CUSTOMER_INITIATED_ACCESS"]
  # }

  lifecycle {
    prevent_destroy = false
  }
}
