# [0-encrypt module] Envelope encryption with Tink

## Overview

This module provides the Terraform bootstrap infrastructure creation (keyring, key encryption key, data encryption key, etc.) needed to encrypt data using Tink envelope encryption.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads);
- [Google Cloud CLI (`gcloud`)](https://cloud.google.com/sdk/docs/install-sdk);
    - You must be authenticated in your GCP account. If you're not you should run `gcloud auth login`;
- An existing [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project);
- Enable GCP services in the project created above:
    - cloudkms.googleapis.com
- [Python 3+](https://www.python.org/downloads/);
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
    **Note:** Copy all the outputs provided by `terraform apply`. They will be required during the decrypt process.

1. All the bootstrap infrastructure is deployed and the desired file is encrypted.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| encrypted\_file\_path | Path to the encrypted file to be output by terraform. | `string` | `"./encrypted_file"` | no |
| input\_file\_path | Path to the input file to be encrypted. | `string` | n/a | yes |
| kek | Key encryption key name. | `string` | n/a | yes |
| keyring | Keyring name. | `string` | n/a | yes |
| location | Location for the resources (keyring, key, network, etc.). | `string` | `"us-central1"` | no |
| prevent\_destroy | Set the prevent\_destroy lifecycle attribute on keys. | `bool` | n/a | yes |
| project\_id | GCP project ID to use for the creation of resources. | `string` | n/a | yes |
| python\_cli\_path | Python CLI base path. | `string` | `".."` | no |
| python\_venv\_path | Python virtual environment path to be created. | `string` | `"../encrypt_venv"` | no |
| suffix | A suffix to be used as an identifier for resources. (e.g., suffix for KMS Key, Keyring, SAs, etc.). | `string` | `""` | no |
| tink\_keyset\_output\_file | Tink keyset output file name. | `string` | `"./encrypted_keyset"` | no |
| tink\_sa\_credentials\_file | Service accounts credential file path required by Tink. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| encrypted\_file\_path | Path to the encrypted file created by by terraform. |
| kek\_key\_uri | KMS Key Encryption Key (KEK) URI. |
| key | Name of the key created. |
| keyring | Name of the keyring. |
| tink\_keyset\_file | Name of tink keyset file created. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
