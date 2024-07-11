# [1-encrypt module] Envelope encryption with Tink

## Overview

This module encrypts a file with envelope encryption using Tink and Terraform.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads);
- [Google Cloud CLI (`gcloud`)](https://cloud.google.com/sdk/docs/install-sdk);
    - You must be authenticated in your GCP account. If you're not you should run `gcloud auth login`;
- An existing Tink encrypted [keyset](https://developers.google.com/tink/design/keysets) file;
- [Go 1.22+](https://go.dev/dl/);

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
    **Note:** Copy all the outputs provided by `terraform apply`. They will be required during the decrypt process.

1. The desired file is now envelope encrypted.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| associated\_data | The associated data in Authenticated Encryption with Associated Data (AEAD) is used to tie ciphertext to specific associated data. Associated data is authenticated but NOT encrypted. | `string` | `"associated_data_sample"` | no |
| cli\_path | CLI base path. | `string` | `"../"` | no |
| encrypted\_file\_path | Path to the encrypted file to be output by terraform. | `string` | `"./envelope_encrypted_file"` | no |
| input\_file\_path | Path to the input file to be encrypted. | `string` | n/a | yes |
| kek\_uri | KMS Key Encryption Key (KEK) URI. | `string` | n/a | yes |
| tink\_keyset\_file | Tink keyset file name. | `string` | n/a | yes |
| tink\_sa\_credentials\_file | Service accounts credential file path required by Tink. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| encrypted\_file\_path | Path to the encrypted file created by terraform. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
