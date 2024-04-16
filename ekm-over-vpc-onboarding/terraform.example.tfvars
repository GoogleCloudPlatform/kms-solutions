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

organization_id              = "REPLACE-WITH-YOUR-ORG-ID"
billing_account              = "REPLACE-WITH-YOUR-BILLING-ACCOUNT"
project_creator_member_email = "" # Set if you want to grant the permissions to a different user than it is authenticated
folder_id                    = "" # Set if you want to create the projects in a specific GCP folder (Applies only when create flag is true)

create_kms_project = false # Set to true if you want to auto-create the KMS project
create_vpc_project = false # Set to true if you want to auto-create the VPC project

kms_project_id        = "sample-kms-project-id" # Desired or existing project KMS name (if existing set create flag to false)
vpc_project_id        = "sample-vpc-project-id" # Desired or existinf project VPC name (if existing set create flag to false)
random_project_suffix = false                   # Set to true if you want to append a 4 random string into project ID (applies only when create flag is true)

kms_project_name = "sample-kms-project-name" # (Applies only when create flag is true)
vpc_project_name = "sample-vpc-project-name" # (Applies only when create flag is true)

external_provider_hostname = "REPLACE-WITH-YOUR-EKM-HOSTNAME"
external_provider_raw_der  = "REPLACE-WITH-YOUR-RAW-DER"  # The raw certificate bytes in DER format. A base64-encoded string. For more info see: https://cloud.google.com/kms/docs/reference/rest/v1/projects.locations.ekmConnections#Certificate
external_key_manager_ip    = "REPLACE-WITH-YOUR-EKM-IP"   # Set with a Private IP address of the EKM or an IP address for the load balancer pointing to the EKM
ekm_connection_key_path    = "REPLACE-WITH-YOUR-KEY-PATH" # Set with Cloud EKM key version.