# Use a Cloud HSM key to serve Apache traffic

## Overview

This guide provides instructions for setting up a GCP infrastructure with Apache server using Cloud HSM key for TLS signing with Terraform.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads);
- [Google Cloud CLI (`gcloud`)](https://cloud.google.com/sdk/docs/install-sdk);
    - You must be authenticated in your GCP account. If you're not you should run `gcloud auth login`;
- An existing [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project);
- Enable GCP services in the project created above:
    - compute.googleapis.com
    - iam.googleapis.com
    - artifactregistry.googleapis.com
    - cloudbuild.googleapis.com
    - cloudkms.googleapis.com

**Note:** You can enable these services using `gcloud services enable <SERVICE>` command or terraform automation would auto-enable them for you.

- (Optional) An existing [GCP Organization](https://cloud.google.com/resource-manager/docs/creating-managing-organization);
    - If you provide a `organization_id` variable in `terraform.tfvars`, the Terraform automation will configure the following organization policies: `constraints/compute.vmExternalIpAccess` and `constraints/iam.disableServiceAccountKeyCreation`;

**Note:** This automation won't work if you use `pkcs11_lib_version` variable lower than `1.3`

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

1. Connect into the Compute Engine VM using IAP and `gcloud` command:
    ```sh
    gcloud compute ssh --zone "us-central1-a" "apache-hostname-example" --tunnel-through-iap --project "REPLACE-WITH-YOUR-EXISTING-PROJECT-ID"
    ```
    **Note:** You can run the command above from Cloud Shell (recommended) or locally (additional permissions may be required)

1.  Run the following command in the Compute Engine VM shell. You should see a succesful request output.
    ```sh
    container_id=$(docker ps -q | head -n 1)
    docker exec "$container_id" curl -v --insecure https://127.0.0.1
    ```
    **Note:** The successful output should contain information about the certificate and a `HTTP/1.1 200 OK` string.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| artifact\_image | Image's name stored in Artifact Registry. | `string` | n/a | yes |
| artifact\_location | Location's name of the image stored in Artifact Registry. | `string` | `"us-central1"` | no |
| artifact\_repository | Respository's name of the image stored in Artifact Registry. | `string` | `"hsm-cloud-example"` | no |
| artifact\_version | Version of the image stored in Artifact Registry. | `string` | `"latest"` | no |
| certificate\_file\_path | Certificate file path to be used on sign process. This should be used when you have a certificate file signed by a Certificate Authority. If not provided, a self-signed certificate will be generated with OpenSSL. Use self-signed certificate for testing only. A self-signed certificate created this way is not appropriate for production use. | `string` | `null` | no |
| certificate\_name | A name for the certificate that you want to generate. This will be used on CN parameter for certificate signing requests or/and self-signed certificates. | `string` | `"TERRAFORM_CERT"` | no |
| digest\_flag | A flag indicating the type of digest. Use sha256, sha384, or sha512 depending on the algorithm of the key. | `string` | `"sha256"` | no |
| docker\_file\_path | The Dockerfile path. | `string` | `"./"` | no |
| hostname | Name of the GCE VM host. | `string` | `"apache-hostname-example"` | no |
| key | Name of the key to be created. | `string` | n/a | yes |
| keyring | Name of the keyring to be created. | `string` | n/a | yes |
| location | Location for the keyring. For available KMS locations see: https://cloud.google.com/kms/docs/locations. | `string` | `"us-central1"` | no |
| organization\_id | GCP organization ID that will used to apply desired Org Policies. If not provided, Org Policies won't be applied. | `string` | `""` | no |
| pkcs11\_lib\_version | Version of the PKCS #11 library version. This automation is not compatible with version lower than 1.3. To see more info about versions available: https://github.com/GoogleCloudPlatform/kms-integrations/releases?q=pkcs%2311&expanded=true | `string` | `"1.3"` | no |
| prevent\_destroy | Set the prevent\_destroy lifecycle attribute on keys. | `bool` | `true` | no |
| project\_id | GCP project ID to use for the creation of resources. | `string` | n/a | yes |
| suffix | A suffix to be used as an identifier for resources. (e.g., suffix for KMS Key, Keyring, SAs, etc.). If not provided, a 4 character random one will be generated. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| key | Name of the key created. |
| keyring | Name of the keyring. |
| location | Location of the keyring created. |
| project\_id | ID of the GCP project being used. |
| service\_account\_email | Service Account created and managed by Terraform. |
| vm\_hostname | Name of the hostname created. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
