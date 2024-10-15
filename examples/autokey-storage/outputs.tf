# /**
#  * Copyright 2024 Google LLC
#  *
#  * Licensed under the Apache License, Version 2.0 (the "License");
#  * you may not use this file except in compliance with the License.
#  * You may obtain a copy of the License at
#  *
#  *      http://www.apache.org/licenses/LICENSE-2.0
#  *
#  * Unless required by applicable law or agreed to in writing, software
#  * distributed under the License is distributed on an "AS IS" BASIS,
#  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  * See the License for the specific language governing permissions and
#  * limitations under the License.
#  */

output "autokey_config_id" {
  description = "An Autokey configuration identifier."
  value       = module.autokey_storage.autokey_config_id
}

output "autokey_storage_keyhandle" {
  description = "A Storage KeyHandle info created."
  value       = module.autokey_storage.autokey_storage_keyhandle
}

output "autokey_resource_project_id" {
  description = "GCP project ID used for the resource using KMS Autokey."
  value       = module.autokey_storage.autokey_resource_project_id
}

output "bucket_name" {
  description = "Bucket name created."
  value       = module.autokey_storage.bucket_name
}

