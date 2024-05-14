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

module "consumer_bootstrap" {
  source = "../../share-encrypted-data-with-partners/consumer/0-bootstrap"

  project_id                 = var.project_id
  keyring                    = "simple-example-keyring"
  key                        = "simple-example-key"
  import_job_public_key_path = "./wrapping-key.pem"
  prevent_destroy            = false
}

module "producer_key_wrap" {
  source = "../../share-encrypted-data-with-partners/producer/"

  key_encryption_key_path  = "./wrapping-key.pem"
  data_encryption_key_path = "./random_example_datakey.bin"
  wrapped_key_path         = "./wrapped-key"

  depends_on = [module.consumer_bootstrap]
}

module "consumer_key_import" {
  source = "../../share-encrypted-data-with-partners/consumer/1-key-import"

  wrapped_key_path = "./wrapped-key"
  depends_on = [module.producer_key_wrap]
}
