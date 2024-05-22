# Use CNG Provider and SignTool to sign Windows artifacts

## Overview

This guide provides instructions for creating a Cloud HSM key for Microsoft Authenticode signing through our CNG provider and [SignTool](https://learn.microsoft.com/en-us/windows/win32/seccrypto/signtool) with Terraform.

**Note:** The Windows infrastructure itself is not automated by this Terraform. Just the resources need to run CNG provider in your Windows machine will be automated.

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

- A Windows (10, Server 2012 R2 or newer versions) machine with the artifacts you want to sign.
    - The latest Cloud KMS [CNG provider release](https://github.com/GoogleCloudPlatform/kms-integrations/releases?q=cng&expanded=true) installed on your Windows machine using the .msi installer.
    - [Google Cloud CLI (`gcloud`)](https://cloud.google.com/sdk/docs/install-sdk) installed and authenticated.
    - [Singtool](https://learn.microsoft.com/en-us/windows/win32/seccrypto/signtool) installed in your Windows machine. Signtool is included in [Windows SDK](https://developer.microsoft.com/en-us/windows/downloads/sdk-archive/) - it's recommend to use [Windows SDK 8.1 version](https://go.microsoft.com/fwlink/p/?LinkId=323507) instead of the newer ones for [compatibility reasons](https://github.com/GoogleCloudPlatform/kms-integrations/issues/19#issuecomment-1914154893).

**Note:** `gcloud` is listed twice in the pre requirements section because is not required to use the same machine to run the Terraform automation and sign the artifacts, even though it can be the same machine.

**Note 2:** This automation won't work if you use `pkcs11_lib_version` variable lower than `1.3`

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
    gcloud compute ssh --zone "us-central1-a" "cng-hostname-example" --tunnel-through-iap --project "REPLACE-WITH-YOUR-EXISTING-PROJECT-ID"
    ```
    **Note:** You can run the command above from Cloud Shell (recommended) or locally (additional permissions may be required)

1.  Run the following command in the Compute Engine VM shell:
    ```sh
    container_id=$(docker ps -q | head -n 1)
    docker exec -it "$container_id" /bin/bash
    ```

1.  Optional step. If your certificate authority (CA) requires a CSR in order to generate a new certificate for code signing, you can have the certificate signing request (CSR) for a Cloud HSM signing key by running the following command:
    ```sh
    cat /opt/request-ca.csr
    ```
    **Note:** You should see a signing request that looks like this:

    ```
    -----BEGIN CERTIFICATE REQUEST-----

    ...

    -----END CERTIFICATE REQUEST-----
    ```

1. Optional step. If your certificate authority (CA) requires a proof that your key resides in an HSM to issue an Extended Validation (EV) certificate you can generate a HSM attestation by running the following commands:
     ```sh
    gcloud kms keys versions describe 1 \
    --key REPLACE-WITH-YOUR-KEY-NAME \
    --location REPLACE-WITH-YOUR-LOCATION \
    --keyring REPLACE-WITH-YOUR-KEYRING-NAME
    ```
    ```sh
    cloudshell download attestation-file # If you're using Cloud Shell, this extra command is required in order to download the file.
    ```
    **Note:** You can run the command above from Cloud Shell (recommended) or locally (additional permissions may be required).

    **Note 2:** You can run `terraform output` locally to get all the info required in replaces.

1. You can check the certificate used in the process of the automation (either self-signed or obtained from the Certificate Authority) by running the following command. You should copy it the output and create the same `ca.cert` file in your Windows machine.
    ```sh
    cat /opt/ca.cert
    ```
    **Note:** You should see a certificate that looks like this:

    ```
    -----BEGIN CERTIFICATE-----

    ...

    -----END CERTIFICATE-----
    ```

1. Now in your Windows machine, use SignTool to sign the artifacts, using your Cloud KMS key and your certificate:
```powershell
"PATH_TO_SIGNTOOL.EXE" sign ^
  /v /debug /fd sha256 /t http://timestamp.digicert.com ^
  /f PATH_TO_CA.CERT ^
  /csp "Google Cloud KMS Provider" ^
  /kc projects/PROJECT_ID/locations/LOCATION/keyRings/KEY_RING/cryptoKeys/KEY_NAME/cryptoKeyVersions/KEY_VERSION ^
  PATH_TO_ARTIFACT_TO_SIGN
```

**Note:** `PATH_TO_SIGNTOOL.EXE`: the path to `signtool.exe` (eg. `C:\\Program Files (x86)\\Windows Kits\\8\\bin\\x64\\signtool.exe`).

**Note 2:** `PATH_TO_CA.CERT`: the path to your certificate `ca.cert`.

**Note 3:** `PATH_TO_ARTIFACT_TO_SIGN`: the path to the artifact that you want to sign.

**Note 4:** `KEY_VERSION`: the version of the Cloud HSM key. Usually `1` if you are using the key that the automation auto-generated.

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
| hostname | Name of the GCE VM host. | `string` | `"cng-hostname-example"` | no |
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
| vm\_hostname | Name of the hostname created. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
