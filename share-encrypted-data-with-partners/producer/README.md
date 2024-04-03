# [Producer module] Raw Encryption: Building infrastructure for sharing encrypted data with partners

## Overview

This module provides the DEK (Data Encryption Key) wrapping process using OpenSSL for raw encryption feature in Cloud KMS with Terraform.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads);
- [OpenSSL](https://www.openssl.org/source/index.html);
- Data Encryption Key (DEK) file generated on key management system (HSM);
    - **Note:** Use your company’s approved method to generate a data encryption key in a secure environment;
    - **Note 2:** For testing purposes a random key generation step will be provided. **Random key created this way is not appropriate for production use.**
- Key Encryption Key (KEK) file;
    - **Note:** Usually an Import Job public key file received from consumer.

## Glossary

- AAD: Additional Authenticated Data
    - The AAD is used for authentication purposes, to ensure the ciphertext has not been altered.
- IV: Initialization Vector
    - The IV, which should be generated randomly, is used as a parameter to make the encryption semantically secure.

## Deploy infrastructure

1. (Optional) **For testing purposes only:** Generate a random DEK (Data Encryption Key) using OpenSSL.
    ```sh
    openssl rand 32 > ./random_datakey.bin
    ```
    **Note:** For production, use your company’s approved method to generate a data encryption key in a secure environment;

1. You can go to [examples folder](../examples/) and choose one of the available encrypt approaches in order to test the generation of the ciphertext, IV and AAD.

1. Rename `terraform.example.tfvars` to `terraform.tfvars`:
    ```sh
    mv terraform.example.tfvars terraform.tfvars
    ```

1. Update `terraform.tfvars` file with the required values.

1. Run the Terraform workflow.

    ```sh
    terraform init
    terraform plan
    terraform apply
    ```

1. The DEK (Data Encryption Key) is now wrapped and ready to be sent to consumer. Wrapped key file, ciphertext, IV, and AAD should be sent to consumer.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| data\_encryption\_key\_path | Path to the key used to encrypt data itself (DEK). A random key can be generated with OpenSSL, see step 1 on README. Use the random key for testing only. A the random key created this way is not appropriate for production use, use your company's approved method to generate a data encryption key in a secure environment instead. | `string` | n/a | yes |
| key\_encryption\_key\_path | Path to where the KEK (Key Encryption Key) is stored. This is usually a public key file extracted from an Import Job received from consumer. | `string` | n/a | yes |
| wrapped\_key\_path | Path to where the wrapped key file should be created. | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
