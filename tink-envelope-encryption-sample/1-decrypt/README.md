# [1-decrypt module] Envelope encryption with Tink

## Overview

This module provides a decrypt of a file previously encypted by the Tink envelope envryption process using Terraform.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads);
- [Google Cloud CLI (`gcloud`)](https://cloud.google.com/sdk/docs/install-sdk);
    - You must be authenticated in your GCP account. If you're not you should run `gcloud auth login`;
- An existing [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project);
- Enable GCP services in the project created above:
    - cloudkms.googleapis.com
- [Go 1.22+](https://go.dev/dl/);
- [pip](https://pip.pypa.io/en/stable/installation/);

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

1. The desired file is now decrypted.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| associated\_data | The associated data in Authenticated Encryption with Associated Data (AEAD) is used to tie ciphertext to specific associated data. Associated data is authenticated but NOT encrypted. | `string` | `"associated_data_sample"` | no |
| cli\_path | CLI base path. | `string` | `"../../tink-envelope-encryption-sample"` | no |
| decrypted\_file\_path | Path to the decrypted file to be output by terraform. | `string` | `"./decrypted_file"` | no |
| encrypted\_file\_path | Path to the encrypted file. | `string` | n/a | yes |
| tink\_kek\_uri | Key encryption key (KEK) URI. | `string` | n/a | yes |
| tink\_keyset\_file | Tink keyset file name. | `string` | n/a | yes |
| tink\_sa\_credentials\_file | Service accounts credential file path required by Tink. | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
