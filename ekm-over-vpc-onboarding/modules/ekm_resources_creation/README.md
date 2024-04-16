# EKM resources creation module

## Overview

This module provides all the EKM infrastructure creation (EKM connection, key, keyring) sample with Terraform.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| crypto\_space\_path | External key provider crypto space path (ie. v0/longlived/a1-example) | `string` | `""` | no |
| ekm\_connection\_key\_path | Each Cloud EKM key version contains either a key URI or a key path. This is a unique identifier for the external key material that Cloud EKM uses when requesting cryptographic operations using the key. When key\_management\_mode is CLOUD\_KMS, this variable will be equals to crypto\_space\_path | `string` | n/a | yes |
| ekmconnection\_name | Name of the ekmconnection resource | `string` | `"ekmconnection"` | no |
| external\_key\_manager\_ip | Private IP address of the external key manager or ip address for the load balancer pointing to the external key manager | `string` | `"10.2.0.48"` | no |
| external\_key\_manager\_port | Port of the external key manager or port for the load balancer pointing to the external key manager | `string` | `"443"` | no |
| external\_provider\_hostname | Hostname for external key manager provider (ie. private-ekm.example.endpoints.cloud.goog) | `string` | n/a | yes |
| external\_provider\_raw\_der | External key provider server certificate in base64 format | `string` | n/a | yes |
| key\_management\_mode | Key management mode. Possible values: MANUAL and CLOUD\_KMS. Defaults to MANUAL | `string` | `"MANUAL"` | no |
| kms\_name\_prefix | Key management resources name prefix | `string` | `"kms-vpc"` | no |
| kms\_project\_id | ID of the KMS project you would like to create | `string` | n/a | yes |
| location | Location where resources will be created | `string` | `"us-central1"` | no |
| network\_name | Name of the Network resource | `string` | `"vpc-network-name"` | no |
| project\_creator\_member\_email | Email of the user that will be granted permissions to create resources under the projects | `string` | `""` | no |
| servicedirectory\_name | Service Directory resource name | `string` | `"ekm-service-directory"` | no |
| subnet\_ip\_cidr\_range | ip\_cidr\_range for subnet resource | `string` | `"10.2.0.0/16"` | no |
| vpc\_project\_id | ID of the VPC project, default to same as KMS | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| crypto\_key | Name of the crypto key created. |
| ekm\_connection\_id | ID of the EKM connection created. |
| key\_version | Name of the key version created. |
| keyring | Name of the keyring. |
| location | Location of the keyring created. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
