# [Consumer 1-key-import module] Raw Encryption: Building infrastructure for sharing encrypted data with partners

## Overview

This module provides the key import process for an existing import job and raw encryption key, using Cloud KMS with Terraform.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads);
- [Google Cloud CLI (`gcloud`)](https://cloud.google.com/sdk/docs/install-sdk);
    - You must be authenticated in your GCP account. If you're not you should run `gcloud auth login`;
- [OpenSSL](https://www.openssl.org/source/index.html);
- Wrapped Data Encryption Key (DEK) file;

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

1. The DEK (Data Encryption Key) is now imported in GCP and ready to be used. You can go to [examples folder](../examples/) and choose one of the available decrypt approaches in order to test the decryption process. Wrapped key file, ciphertext, IV, and AAD will be required.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| crypto\_key\_algorithm\_import | Algorithm to use when creating a crypto key version through import. See more: https://cloud.google.com/sdk/gcloud/reference/kms/keys/versions/import. | `string` | `"aes-256-gcm"` | no |
| wrapped\_key\_path | Path to the wrapped key file. | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
