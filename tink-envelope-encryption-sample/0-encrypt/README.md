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
| python\_venv\_path | Python virtual environment path to be created. | `string` | `"../venv"` | no |
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
