# [1-encrypt module] Envelope encryption

## Overview

This module encrypts a file with envelope encryption using Terraform.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads);
- [Google Cloud CLI (`gcloud`)](https://cloud.google.com/sdk/docs/install-sdk);
    - You must be authenticated in your GCP account. If you're not you should run `gcloud auth login`;
- An existing wrapped key file provided by 0-bootstrap module execution;
- [Python 3+](https://www.python.org/downloads/);
- [pip](https://pip.pypa.io/en/stable/installation/);

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

1. The desired file is now envelope encrypted.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cli\_path | CLI base path. | `string` | `"../python-cli"` | no |
| input\_file\_path | Sensitive file to be encrypted. | `string` | n/a | yes |
| kek\_name | Key encryption key name. | `string` | n/a | yes |
| keyring\_name | Keyring name. | `string` | n/a | yes |
| location | Location for the resources (keyring, key, network, etc.). | `string` | `"us-central1"` | no |
| output\_file\_path | Encrypted file path output. | `string` | `"../encrypted_file"` | no |
| project\_id | GCP project ID to use for the creation of resources. | `string` | n/a | yes |
| wrapped\_key\_path | Wrapped Data Encryption Key file. | `string` | `"../wrapped_dek"` | no |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
