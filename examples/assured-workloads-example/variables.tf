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

variable "org_id" {
  description = "The Organization ID."
  type        = string
}

variable "billing_account" {
  description = "The Billing Account ID."
  type        = string
}

variable "folder_id" {
  description = "Root folder ID for the workload."
  type        = string
}

variable "aw_compliance_regime" {
  description = "Compliance regime of the workload. You can check the supported values in https://cloud.google.com/assured-workloads/docs/reference/rest/Shared.Types/ComplianceRegime."
  type        = string
}

variable "aw_location" {
  description = "Workload location."
  type        = string
}

variable "aw_name" {
  description = "Base name of the workload."
  type        = string
}

variable "cryptokey_allowed_access_reasons" {
  description = "The list of allowed reasons for access to this CryptoKey. You can check the supported values in https://cloud.google.com/assured-workloads/key-access-justifications/docs/justification-codes."
  type        = list(string)

  # TODO: Change the default to null when bugs XXX and YYY are fixed.
  default = [
    "CUSTOMER_INITIATED_ACCESS",
    "MODIFIED_CUSTOMER_INITIATED_ACCESS",
    "GOOGLE_INITIATED_SYSTEM_OPERATION", "MODIFIED_GOOGLE_INITIATED_SYSTEM_OPERATION"
  ]
}

variable "new_allowed_restricted_services" {
  description = "The list of the restricted services that will be added as allowed. See the list of supported products by control package in https://cloud.google.com/assured-workloads/docs/supported-products."
  type        = list(string)
  default = [
    "bigquery.googleapis.com",
    "bigqueryconnection.googleapis.com",
    "bigquerydatapolicy.googleapis.com",
    "bigquerydatatransfer.googleapis.com",
    "bigquerymigration.googleapis.com",
    "bigqueryreservation.googleapis.com",
    "bigquerystorage.googleapis.com",
    "file.googleapis.com",
    "networksecurity.googleapis.com"
  ]
}
