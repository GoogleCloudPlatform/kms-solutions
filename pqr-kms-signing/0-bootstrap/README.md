# [0-bootstrap module] PQR (Post Quantum Ready) KMS Signing

## Overview

This module provides the Terraform bootstrap infrastructure creation (KeyRing and a Post-Quantum Ready signing key) needed for the PQR (Post Quantum Ready) KMS signing example.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads);
- [Google Cloud CLI (`gcloud`)](https://cloud.google.com/sdk/docs/install-sdk);
    - You must be authenticated in your GCP account. If you're not you should run `gcloud auth login`;
- An existing [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project);
- Enable GCP services in the project created above:
    - cloudkms.googleapis.com

**Note:** You can enable these services using `gcloud services enable <SERVICE>` command or terraform automation would auto-enable them for you.

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

1. All the bootstrap infrastructure is deployed and the document can now be signed by following the instructions in the main README.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| algorithm | The post-quantum signing algorithm for the KMS crypto key. | `string` | `"PQ_SIGN_ML_DSA_87"` | no |
| enable\_services | Whether to enable the necessary Google Cloud services. | `bool` | `true` | no |
| key\_name | The name of the post-quantum signing key. | `string` | `"pqr-signing-key"` | no |
| key\_protection\_level | The protection level to use when creating a version based on this template. Default value: SOFTWARE. | `string` | `"SOFTWARE"` | no |
| key\_rotation\_period | The period of time that should elapse between automatic rotations of a key. It must be at least 24 hours. | `string` | `""` | no |
| keyring\_name | The name of the KMS key ring. | `string` | `"pqr-keyring"` | no |
| location | The Google Cloud location for the KMS key ring. | `string` | `"us-east1"` | no |
| prevent\_destroy | Whether to prevent destruction of the KMS key. | `bool` | `true` | no |
| project\_id | The Google Cloud project ID where KMS resources will be created. | `string` | n/a | yes |
| purpose | The immutable purpose of the CryptoKey. Default value: ASYMMETRIC\_SIGN. | `string` | `"ASYMMETRIC_SIGN"` | no |

## Outputs

| Name | Description |
|------|-------------|
| key\_name | The name of the post-quantum signing key. |
| key\_ring\_id | The ID of the created KMS key ring. |
| keyring\_name | The name of the KMS key ring. |
| kms\_key\_uri | KMS key URI in tink-go format |
| location | The location of the KMS key ring. |
| signing\_key\_id | The resource ID of the post-quantum signing key. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
