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

module "pkcs11_apache_web_server" {
  source = "../../pkcs-11-terraform-automation/1-apache-web-server"

  project_id       = var.project_id
  keyring          = "sample-keyring"
  key              = "sample-key"
  artifact_image   = "sample-image"
  prevent_destroy  = false
  docker_file_path = "../../pkcs-11-terraform-automation/1-apache-web-server"
}
