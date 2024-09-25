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

module "assured_workloads" {
  source = "../../assured-workloads"

  org_id               = var.org_id
  billing_account      = var.billing_account
  folder_id            = var.folder_id
  aw_name              = "AW-Wkld-EX"
  aw_compliance_regime = "JP_REGIONS_AND_SUPPORT"
  aw_location          = "asia-northeast1"
  new_allowed_restricted_services = [
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
  cryptokey_allowed_access_reasons = [
    "CUSTOMER_INITIATED_ACCESS",
    "MODIFIED_CUSTOMER_INITIATED_ACCESS",
    "GOOGLE_INITIATED_SYSTEM_OPERATION", "MODIFIED_GOOGLE_INITIATED_SYSTEM_OPERATION"
  ]
}
