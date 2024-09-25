# Assured Workloads

## Overview

A prototype module for Assured Workloads.

> Note: This is a placeholder for a more complete README to be developed.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aw\_base\_id | Base ID used as prefix to create other resources's IDs like: folders, projects, keyrings, keys etc. | `string` | `"aw-workload"` | no |
| aw\_compliance\_regime | Compliance regime of the workload. You can check the supported values in https://cloud.google.com/assured-workloads/docs/reference/rest/Shared.Types/ComplianceRegime. | `string` | n/a | yes |
| aw\_location | Workload location. | `string` | n/a | yes |
| aw\_name | Base name of the workload. | `string` | n/a | yes |
| billing\_account | The Billing Account ID. | `string` | n/a | yes |
| cryptokey\_allowed\_access\_reasons | The list of allowed reasons for access to this CryptoKey. You can check the supported values in https://cloud.google.com/assured-workloads/key-access-justifications/docs/justification-codes. | `list(string)` | `null` | no |
| folder\_id | Root folder ID for the workload. | `string` | n/a | yes |
| new\_allowed\_restricted\_services | The list of the restricted services that will be added as allowed. See the list of supported products by control package in https://cloud.google.com/assured-workloads/docs/supported-products. | `list(string)` | `[]` | no |
| org\_id | The Organization ID. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| aw\_id | Assured Workload ID. |
| aw\_kaj\_enrollment\_state | Key Access Justification Enrollment State. |
| aw\_name | Assured Workload name. |
| aw\_provisioned\_resources\_parent | Parent of the Assured Workload. |
| aw\_resource\_settings | Resource settings of the Assured Workload. |
| aw\_resources | Resources of the Assured Workload. |
| kms\_key\_id | Crypto Key ID. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
