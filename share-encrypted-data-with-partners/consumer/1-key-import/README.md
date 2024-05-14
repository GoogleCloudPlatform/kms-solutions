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
| import\_job\_id | ID of the import job created in 0-bootstrap module | `string` | n/a | yes |
| key | Name of the key to be created. | `string` | n/a | yes |
| keyring | Name of the keyring to be created. | `string` | n/a | yes |
| location | Location for the keyring. For available KMS locations see: https://cloud.google.com/kms/docs/locations. | `string` | `"us-central1"` | no |
| project\_id | GCP project ID to use for the creation of resources. | `string` | n/a | yes |
| wrapped\_key\_path | Path to the wrapped key file. | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
