# Google KMS Autokey setup Terraform Module

Simple Cloud KMS Autokey setup module that can be used to create requirements for [Autokey](https://cloud.google.com/kms/docs/autokey-overview) feature.

This is usually deployed by a [Security administrator](https://cloud.google.com/kms/docs/autokey-overview#how-autokey-works) role.

The capabilities of this module are:

- Create a GCP folder to be used with Autokey;
- Create a GCP project using [project-factory module](https://github.com/terraform-google-modules/terraform-google-project-factory) to be used as a KMS key project with Autokey feature;

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| autokey\_folder\_id | Autokey folder ID to be created or used. | `string` | `"folder-autokey"` | no |
| autokey\_key\_project\_id | GCP project ID to be created or used for KMS Autokey keys. | `string` | `"autokey-key-project-id"` | no |
| autokey\_key\_project\_name | GCP project name to be used for KMS Autokey key project. Used only when create\_autokey\_key\_project is true. | `string` | `"autokey-key-project-name"` | no |
| autokey\_parent | The parent of the Autokey folder. It can be an organization or a folder. Format: organization/<org\_number> or folders/<folder\_number>. Used only when create\_autokey\_folder is true. | `string` | `""` | no |
| billing\_account | The ID of the billing account to associate projects with. | `string` | n/a | yes |
| create\_autokey\_folder | A new GCP folder will be created for Autokey if true. | `bool` | `true` | no |
| create\_autokey\_key\_project | A new GCP project will be created for Autokey keys if true. | `bool` | `true` | no |
| deletion\_policy | The deletion policy for the project. | `string` | `"DELETE"` | no |
| folder\_deletion\_protection | The deletion protection for the folder. | `bool` | `false` | no |
| suffix | A suffix to be used as an identifier for resources. (e.g., suffix for KMS Key, Keyring, SAs, etc.). | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| autokey\_folder\_id | The Autokey folder used for KMS Autokey. |
| autokey\_key\_project\_id | GCP project ID used for KMS Autokey keys. |
| random\_suffix | Random suffix created to append the resource names. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
