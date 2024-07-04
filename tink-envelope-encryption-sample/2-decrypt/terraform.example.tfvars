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

# You can find all these inputs values in 0-encrypt module outputs by running `terraform output` at the 0-encrypt path.

encrypted_file_path      = "REPLACE-WITH-YOUR-ENCRYPTED-FILE-PATH"
kek_uri                  = "REPLACE-WITH-YOUR-KEK-URI" # Format expected: "gcp-kms://projects/PROJECT-ID/locations/us-central1/keyRings/KEYRING/cryptoKeys/CRYPTOKEY"
tink_keyset_file         = "REPLACE-WITH-YOUR-KEYSET-FILE-PATH"
tink_sa_credentials_file = "REPLACE-WITH-YOUR-SA-CREDENTIALS-KEY-FILE-PATH"
associated_data          = "associated_data_sample"
