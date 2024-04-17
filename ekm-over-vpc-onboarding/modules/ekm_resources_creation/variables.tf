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

#####
# Run: terraform apply -var='kms_project_name=my_kms_project' -var="vpc_project_name=my_vpc_project"
# Pre-Req: Allow External Key Manager to receive requests from 35.199.192.0/19
#####

# Variables Required
variable "kms_project_id" {
  type        = string
  nullable    = false
  description = "ID of the KMS project you would like to create"
}

variable "vpc_project_id" {
  type        = string
  default     = ""
  description = "ID of the VPC project, default to same as KMS"
}

variable "location" {
  type        = string
  default     = "us-central1"
  nullable    = false
  description = "Location where resources will be created"
}

variable "subnet_ip_cidr_range" {
  type        = string
  default     = "10.2.0.0/16"
  nullable    = false
  description = "ip_cidr_range for subnet resource"
}

variable "external_key_manager_ip" {
  type        = string
  default     = "10.2.0.48"
  nullable    = false
  description = "Private IP address of the external key manager or ip address for the load balancer pointing to the external key manager"
}

variable "external_key_manager_port" {
  type        = string
  default     = "443"
  nullable    = false
  description = "Port of the external key manager or port for the load balancer pointing to the external key manager"
}

variable "external_provider_hostname" {
  type        = string
  nullable    = false
  description = "Hostname for external key manager provider (ie. private-ekm.example.endpoints.cloud.goog)"
}

variable "external_provider_raw_der" {
  type        = string
  nullable    = false
  description = "External key provider server certificate in base64 format"
}

variable "crypto_space_path" {
  type        = string
  default     = ""
  description = "External key provider crypto space path (ie. v0/longlived/a1-example)"
}

variable "ekm_connection_key_path" {
  type        = string
  description = "Each Cloud EKM key version contains either a key URI or a key path. This is a unique identifier for the external key material that Cloud EKM uses when requesting cryptographic operations using the key. When key_management_mode is CLOUD_KMS, this variable will be equals to crypto_space_path"
}

# Variables Optional
variable "network_name" {
  type        = string
  default     = "vpc-network-name"
  description = "Name of the Network resource"
}

variable "servicedirectory_name" {
  type        = string
  default     = "ekm-service-directory"
  description = "Service Directory resource name"
}

variable "kms_name_prefix" {
  type        = string
  default     = "kms-vpc"
  description = "Key management resources name prefix"
}

variable "ekmconnection_name" {
  type        = string
  default     = "ekmconnection"
  description = "Name of the ekmconnection resource"
}

variable "key_management_mode" {
  type        = string
  default     = "MANUAL"
  description = "Key management mode. Possible values: MANUAL and CLOUD_KMS. Defaults to MANUAL"
}

variable "project_creator_member_email" {
  type        = string
  default     = ""
  description = "Email of the user that will be granted permissions to create resources under the projects"
}
