# KMS EKM connection over a VPC onboarding

## Overview

This guide provides instructions of an automation for Cloud External Key Manager (Cloud EKM) to connect to your external key management (EKM) provider over a Virtual Private Cloud (VPC) network with Terraform.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5.7;
- [Google Cloud CLI (`gcloud`)](https://cloud.google.com/sdk/docs/install-sdk);
    - You must be authenticated in your GCP account. If you're not, you should run `gcloud auth login`;
    - Some IAM permissions will be granted to the authenticated user by this terraform automation. If you want to grant to other user instead, fulfill `project_creator_member_email` in your `terraform.tfvars` file.
- An existing [GCP Organization](https://cloud.google.com/resource-manager/docs/creating-managing-organization);
    - [Project Creator role](https://cloud.google.com/resource-manager/docs/default-access-control#adding_a_billing_account_creator_and_project_creator) in the GCP Organization for the authenticated user;
- (Optional) An existing [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project) to create all the VPC related resources;
- (Optional) An existing [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project) to create all the KMS related resources;

**Note:** VPC and KMS projects are optional because this terraform automation can auto-create them for you. All you need to do is to set `create_kms_project` and `create_vpc_project` to `true` in your `terraform.tfvars` file.

**Note 2:** Your EKM provider should be placed/referenced in your VPC project. A Private IP address of the EKM or an IP address for the load balancer pointing to the EKM is required in your `terraform.tfvars` file.

## Deploy infrastructure

1. Rename `terraform.example.tfvars` to `terraform.tfvars`:
    ```sh
    mv terraform.example.tfvars terraform.tfvars
    ```

1. Update `terraform.tfvars` file with the required values.

1. Create the infrastructure.

    ```sh
    terraform init
    terraform plan
    terraform apply
    ```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| billing\_account | Billing Account for the customer | `string` | `""` | no |
| create\_kms\_project | If true, a project for KMS will be created automatically | `bool` | `true` | no |
| create\_vpc\_project | If true, a project for VPC will be created automatically | `bool` | `true` | no |
| crypto\_space\_path | External key provider crypto space path (ie. v0/longlived/a1-example) | `string` | `""` | no |
| ekm\_connection\_key\_path | Each Cloud EKM key version contains either a key URI or a key path. This is a unique identifier for the external key material that Cloud EKM uses when requesting cryptographic operations using the key. When key\_management\_mode is CLOUD\_KMS, this variable will be equals to crypto\_space\_path | `string` | n/a | yes |
| ekmconnection\_name | Name of the ekmconnection resource | `string` | `"ekmconnection"` | no |
| external\_key\_manager\_ip | Private IP address of the external key manager or ip address for the load balancer pointing to the external key manager | `string` | `"10.2.0.48"` | no |
| external\_key\_manager\_port | Port of the external key manager or port for the load balancer pointing to the external key manager | `string` | `"443"` | no |
| external\_provider\_hostname | Hostname for external key manager provider (ie. private-ekm.example.endpoints.cloud.goog) | `string` | n/a | yes |
| external\_provider\_raw\_der | External key provider server certificate in base64 format | `string` | n/a | yes |
| folder\_id | (Optional) The ID of the GCP folder to create the projects | `string` | `""` | no |
| key\_management\_mode | Key management mode. Possible values: MANUAL and CLOUD\_KMS. Defaults to MANUAL | `string` | `"MANUAL"` | no |
| kms\_name\_prefix | Key management resources name prefix | `string` | `"kms-vpc"` | no |
| kms\_project\_id | ID of the KMS project you would like to create | `string` | `""` | no |
| kms\_project\_name | Name of the KMS project you would like to create | `string` | n/a | yes |
| location | Location where resources will be created | `string` | `"us-central1"` | no |
| network\_name | Name of the Network resource | `string` | `"vpc-network-name"` | no |
| organization\_id | The ID of the existing GCP organization | `string` | n/a | yes |
| project\_creator\_member\_email | Email of the user that will be granted permissions to create resources under the projects | `string` | `""` | no |
| random\_project\_suffix | If true, a suffix of 4 random characters will be appended to project names. Only applies when create project flag is true. | `bool` | `false` | no |
| servicedirectory\_name | Service Directory resource name | `string` | `"ekm-service-directory"` | no |
| subnet\_ip\_cidr\_range | ip\_cidr\_range for subnet resource | `string` | `"10.2.0.0/16"` | no |
| vpc\_project\_id | ID of the VPC project, default to same as KMS | `string` | `""` | no |
| vpc\_project\_name | Name of the VPC project, default to same as KMS | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| crypto\_key | Name of the crypto key created. |
| ekm\_connection\_id | ID of the EKM connection created. |
| key\_version | Name of the key version created. |
| keyring | Name of the keyring. |
| kms\_project\_id | ID of the KMS project |
| location | Location of the keyring created. |
| vpc\_project\_id | ID of the VPC project |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
