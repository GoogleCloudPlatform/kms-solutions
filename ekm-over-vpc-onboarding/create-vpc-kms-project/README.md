# KMS and VPC projects creation script

## Overview

This module provides the Terraform infrastructure project creation for an EKM connection with all the required services enabled.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| billing\_account | Billing Account for the customer | `string` | `""` | no |
| create\_kms\_project | If true, a project for KMS will be created automatically | `bool` | `true` | no |
| create\_vpc\_project | If true, a project for VPC will be created automatically | `bool` | `true` | no |
| folder\_id | (Optional) The ID of the GCP folder to create the projects | `string` | `""` | no |
| kms\_project\_id | ID of the KMS project you would like to create | `string` | `""` | no |
| kms\_project\_name | Name of the KMS project you would like to create | `string` | n/a | yes |
| organization\_id | The ID of the existing GCP organization | `string` | n/a | yes |
| project\_creator\_member\_email | Email of the user that will be granted permissions to create resources under the projects | `string` | `""` | no |
| random\_project\_suffix | If true, a suffix of 4 random characters will be appended to project names. Only applies when create project flag is true. | `bool` | `false` | no |
| vpc\_project\_id | ID of the VPC project, default to same as KMS | `string` | `""` | no |
| vpc\_project\_name | Name of the VPC project, default to same as KMS | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| kms\_project\_id | ID of the KMS project |
| vpc\_project\_id | ID of the VPC project |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
