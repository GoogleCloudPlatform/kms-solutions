# Google KMS Autokey Storage Terraform Module

Simple Cloud KMS Autokey Storage module that can be used to create a bucket configured with [Autokey](https://cloud.google.com/kms/docs/autokey-overview) feature.

The capabilities of this module are:

- Create a GCP project using [project-factory module](https://github.com/terraform-google-modules/terraform-google-project-factory) to be used as a resource project with Autokey feature;
- Enable Cloud KMS Autokey on an existing GCP folder using an exising GCP key project;
    - **Note:** (Optional) It's possible to use [0-setup module](../0-setup/README.md) to create the required folder and key project;
- Create the [KeyHandle](https://cloud.google.com/kms/docs/resource-hierarchy#key_handles) resource for Storage Bucket;
- Create a Storage Bucket configured to use an Autokey key as the bucket default encryption key;

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| autokey\_folder\_id | Autokey folder ID to be created or used. | `string` | n/a | yes |
| autokey\_handle\_name | Autokey Ken Handle name. | `string` | `"key-handle-storage-bucket"` | no |
| autokey\_key\_project\_id | GCP project ID to be used for KMS Autokey keys. | `string` | n/a | yes |
| autokey\_resource\_project\_id | GCP project ID to be created or used for the resource using KMS Autokey. | `string` | `"autokey-res-project-id"` | no |
| autokey\_resource\_project\_name | GCP project name to be used for the resource using KMS Autokey. Used only when create\_autokey\_resource\_project is true. | `string` | `"autokey-res-project-name"` | no |
| billing\_account | The ID of the billing account to associate projects with. | `string` | n/a | yes |
| bucket\_name | Name of the bucket to be created. | `string` | `"autokey-bucket-example"` | no |
| create\_autokey\_resource\_project | A new GCP project will be created for the resouce using Autokey if true. | `bool` | `true` | no |
| deletion\_policy | The deletion policy for the project. | `string` | `"DELETE"` | no |
| location | Location to create the resources. | `string` | `"us-central1"` | no |
| suffix | A suffix to be used as an identifier for resources. (e.g., suffix for KMS Key, Keyring, SAs, etc.). | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| autokey\_config\_id | An Autokey configuration identifier. |
| autokey\_resource\_project\_id | GCP project ID used for the resource using KMS Autokey. |
| autokey\_storage\_keyhandle | A Storage KeyHandle info created. |
| bucket\_name | Bucket name created. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
