# Google KMS Autokey Terraform Module

Simple Cloud KMS Autokey module that allows creating an initial Autokey configuration.

The resources/services/activations/deletions that this module will create/trigger are:

- Create a GCP folder to be used with Autokey;
- Create a GCP project using [project-factory module](https://github.com/terraform-google-modules/terraform-google-project-factory) to be used with Autokey;
- Assign Autokey required IAM roles for KMS service identity;
- Create an initial Autokey configuration;

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| autokey\_folder | The Autokey folder name to be created. | `string` | `"folder-autokey"` | no |
| autokey\_parent | The parent of the Autokey folder to be created. It can be an organization or a folder. Format: organization/<org\_number> or folders/<folder\_number> | `any` | n/a | yes |
| billing\_account | The ID of the billing account to associate projects with. | `string` | n/a | yes |
| kms\_project\_id | GCP project ID to be created and used for KMS Autokey. | `string` | `"kms-autokey-project-id"` | no |
| kms\_project\_name | GCP project name to be created and used for KMS Autokey. | `string` | `"kms-autokey-project-name"` | no |
| suffix | A suffix to be used as an identifier for resources. (e.g., suffix for KMS Key, Keyring, SAs, etc.). | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| autokey\_config | A Autokey identifier. |
| autokey\_folder | The Autokey folder created. |
| kms\_project\_id | GCP project ID created for KMS Autokey. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
