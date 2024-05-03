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

module "restrict-vm-external-ips" {
  count = var.organization_id != "" ? 1 : 0

  source  = "terraform-google-modules/org-policy/google//modules/restrict_vm_external_ips"
  version = "~> 5.0"

  policy_for      = "organization"
  organization_id = var.organization_id
}

module "organization_policies_type_boolean" {
  count   = var.organization_id != "" ? 1 : 0
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  organization_id = var.organization_id
  policy_for      = "organization"
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/iam.disableServiceAccountKeyCreation"
}
