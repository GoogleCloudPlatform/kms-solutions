<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| decrypted\_file\_path | Path to the decrypted file to be output by terraform. | `string` | `"./decrypted_file"` | no |
| encrypted\_file\_path | Path to the encrypted file. | `string` | n/a | yes |
| python\_cli\_path | Python CLI base path. | `string` | `".."` | no |
| python\_venv\_path | Python virtual environment path to be created. | `string` | `"../venv"` | no |
| tink\_kek\_uri | Key encryption key (KEK) URI. | `string` | n/a | yes |
| tink\_keyset\_file | Tink keyset file name. | `string` | n/a | yes |
| tink\_sa\_credentials\_file | Service accounts credential file path required by Tink. | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
