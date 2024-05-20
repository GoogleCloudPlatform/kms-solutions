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

variable "kms_project_name" {
  type        = string
  nullable    = false
  description = "Name of the KMS project you would like to create"
}

variable "organization_id" {
  type        = string
  nullable    = false
  description = "The ID of the existing GCP organization"
}

variable "kms_project_id" {
  type        = string
  default     = ""
  nullable    = false
  description = "ID of the KMS project you would like to create"
}

variable "vpc_project_name" {
  type        = string
  default     = ""
  description = "Name of the VPC project, default to same as KMS"
}

variable "vpc_project_id" {
  type        = string
  default     = ""
  description = "ID of the VPC project, default to same as KMS"
}

variable "billing_account" {
  type        = string
  default     = ""
  description = "Billing Account for the customer"
}

variable "folder_id" {
  type        = string
  default     = ""
  description = "(Optional) The ID of the GCP folder to create the projects"
}

variable "create_kms_project" {
  type        = bool
  default     = true
  description = "If true, a project for KMS will be created automatically"
}

variable "create_vpc_project" {
  type        = bool
  default     = true
  description = "If true, a project for VPC will be created automatically"
}

variable "random_project_suffix" {
  type        = bool
  default     = false
  description = "If true, a suffix of 4 random characters will be appended to project names. Only applies when create project flag is true."
}

variable "access_context_manager_policy_id" {
  type        = string
  default     = ""
  description = "Access context manager access policy ID. Used only when enable_vpc_sc flag is true. If empty, a new access context manager access policy will be created."
}

variable "enable_vpc_sc" {
  type        = bool
  description = "VPC Service Controls define a security perimeter around Google Cloud resources to constrain data within a VPC and mitigate data exfiltration risks."
}

variable "access_level_members_name" {
  type        = string
  default     = "ekm_vpc_sc_access_level_member"
  description = "Description of the AccessLevel and its use. Does not affect behavior."
}

variable "access_level_members" {
  type        = list(string)
  default     = []
  description = "Condition - An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}."
}

variable "perimeter_name" {
  type        = string
  default     = "ekm_perimeter"
  description = "Name of the perimeter. Should be one unified string. Must only be letters, numbers and underscores."
}
