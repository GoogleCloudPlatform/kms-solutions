<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| artifact\_image | Image's name stored in Artifact Registry. | `string` | n/a | yes |
| artifact\_location | Location's name of the image stored in Artifact Registry. | `string` | n/a | yes |
| artifact\_repository | Respository's name of the image stored in Artifact Registry. | `string` | n/a | yes |
| artifact\_version | Version of the image stored in Artifact Registry. | `string` | n/a | yes |
| certificate\_file\_path | Certificate file path to be used on sign process. This should be used when you have a certificate file signed by a Certificate Authority. If not provided, a self-signed certificate will be generated with OpenSSL. Use self-signed certificate for testing only. A self-signed certificate created this way is not appropriate for production use. | `string` | `null` | no |
| certificate\_name | A name for the certificate that you want to generate. This will be used on CN parameter for certificate signing requests or/and self-signed certificates. | `string` | `"TERRAFORM_CERT"` | no |
| cos\_image | Custom OS image desired for the VM. | `string` | `"cos-stable-109-17800-66-57"` | no |
| digest\_flag | A flag indicating the type of digest. Use sha256, sha384, or sha512 depending on the algorithm of the key. | `string` | `"sha256"` | no |
| docker\_file\_path | The Dockerfile path. | `string` | `"./"` | no |
| hostname | Name of the VM host. | `string` | n/a | yes |
| key | Key name. | `string` | n/a | yes |
| keyring | Keyring name. | `string` | n/a | yes |
| location | Location for the resources (keyring, key, network, etc.). | `string` | n/a | yes |
| machine\_type | Type of the GCE VM. | `string` | `"n1-standard-1"` | no |
| network\_name | VPC network name. | `string` | `"custom-hsm-network"` | no |
| organization\_id | GCP organization ID that will used to apply desired Org Policies. If not provided, Org Policies won't be applied. | `string` | `""` | no |
| pkcs11\_lib\_version | Version of the PKCS #11 library version. To see more info about versions available: https://github.com/GoogleCloudPlatform/kms-integrations/releases?q=pkcs%2311&expanded=true | `string` | n/a | yes |
| prevent\_destroy | Set the prevent\_destroy lifecycle attribute on keys. | `bool` | n/a | yes |
| project\_id | GCP project ID to use for the creation of resources. | `string` | n/a | yes |
| region | GCP region to use for the creation of resources. | `string` | `"us-central1"` | no |
| service\_account | Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template#service_account. | <pre>object({<br>    email  = string,<br>    scopes = set(string)<br>  })</pre> | `null` | no |
| subnetwork\_name | VPC subnetwork name. | `string` | `"custom-hsm-subnetwork"` | no |
| suffix | A suffix to be used as an identifier for resources. (e.g., suffix for KMS Key, Keyring, SAs, etc.). | `string` | n/a | yes |
| zone | GCP zone to use for the creation of resources. | `string` | `"us-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| artifact\_registry\_repository\_name | Name of the Artifact Registry repository created. |
| custom\_service\_account\_email | Service Account created and managed by Terraform used to trigger Cloud Build jobs. |
| key | Name of the key created. |
| keyring | Name of the keyring created. |
| location | Location of the keyring. |
| project\_id | ID of the GCP project being used. |
| suffix | A suffix used as an identifier for resources. (e.g., suffix for KMS Key, Keyring, SAs, etc.) |
| vm\_hostname | Name of the hostname created. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
