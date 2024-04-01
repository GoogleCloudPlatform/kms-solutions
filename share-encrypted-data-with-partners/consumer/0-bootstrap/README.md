# [Consumer 0-bootstrap module] Raw Encryption: Building infrastructure for sharing encrypted data with partners

## Overview

This module provides the Terraform bootstrap infrastructure creation (keyring, key and import job) needed to exchange encrypted data with partners through Cloud KMS raw encryption.

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
    **Note:** Copy all the outputs provided by `terraform apply`. They will be required during the encrypt/decrypt process.

1. All the bootstrap infrastructure required to receive encrypted data (wrapped DEK and ciphertext) from the sender using raw encryption is deployed. You can now send the Import Job public key file (stored in `import_job_public_key_path`) to the sender so that they can go through the DEK (Data Encryption Key) wrapping process.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| crypto\_key\_algorithm\_template | Algorithm to use when creating a key template. See more: https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm. | `string` | `"AES_256_GCM"` | no |
| import\_job\_method | Wrapping method to be used for incoming key material. See more: https://cloud.google.com/kms/docs/key-wrapping. | `string` | `"rsa-oaep-4096-sha256"` | no |
| import\_job\_public\_key\_path | Path to import job public key that will be auto-generated. The DEK is encrypted (also known as wrapped) by a key encryption key (KEK) provided by import job. | `string` | n/a | yes |
| key | Name of the key to be created. | `string` | n/a | yes |
| keyring | Name of the keyring to be created. | `string` | n/a | yes |
| location | Location for the keyring. For available KMS locations see: https://cloud.google.com/kms/docs/locations. | `string` | `"us-central1"` | no |
| prevent\_destroy | Set the prevent\_destroy lifecycle attribute on keys. | `bool` | `true` | no |
| project\_id | GCP project ID to use for the creation of resources. | `string` | n/a | yes |
| suffix | A suffix to be used as an identifier for resources. (e.g., suffix for KMS Key, Keyring, SAs, etc.). If not provided, a 4 character random one will be generated. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| import\_job\_id | ID of the Import Job created. |
| key | Name of the key created. |
| keyring | Name of the keyring. |
| location | Location of the keyring created. |
| project\_id | ID of the GCP project being used. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
