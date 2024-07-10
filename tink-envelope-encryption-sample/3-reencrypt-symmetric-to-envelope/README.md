# [3-reencrypt-symmetric-to-envelope module] Envelope encryption with Tink

## Overview

This module provides a symmetric decrypting of a file using an existing GCP KMS Crypto Key and an envelope encryption process of the same file using Tink and Terraform.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads);
- [Google Cloud CLI (`gcloud`)](https://cloud.google.com/sdk/docs/install-sdk);
    - You must be authenticated in your GCP account. If you're not you should run `gcloud auth login`;
- An existing [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project) with a KMS symmetric key created;
    - And a file encrypted with this KMS symmetric key;
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

1. The desired file is now decrypted.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| associated\_data | The associated data in Authenticated Encryption with Associated Data (AEAD) is used to tie ciphertext to specific associated data. Associated data is authenticated but NOT encrypted. | `string` | `"associated_data_sample"` | no |
| cli\_path | CLI base path. | `string` | `"../"` | no |
| current\_encrypted\_file\_path | Path to the symmetric encrypted file to be used. | `string` | n/a | yes |
| current\_key | Key encryption name used to symmetric encryption. | `string` | n/a | yes |
| current\_keyring | Keyring name used to symmetric encryption. | `string` | n/a | yes |
| current\_project\_id | GCP project ID of the KMS used to symmetric encryption. | `string` | n/a | yes |
| encrypted\_file\_path | Path to the encrypted file to be output by terraform. | `string` | `"./envelope_encrypted_file"` | no |
| kek\_uri | KMS Key Encryption Key (KEK) URI. | `string` | n/a | yes |
| location | Location for the resources used to symmetric encryption. | `string` | `"us-central1"` | no |
| rotate\_encrypted\_file\_path | Path to the encrypted file to be used to envelope encryption on rotation. | `string` | `"./file_to_be_envelope_encrypted"` | no |
| tink\_keyset\_file | Tink keyset file name. | `string` | n/a | yes |
| tink\_sa\_credentials\_file | Service accounts credential file path required by Tink. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| encrypted\_file\_path | Path to the encrypted file created by terraform. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
