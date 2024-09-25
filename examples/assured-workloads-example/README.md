# Assured Workloads

## Overview

Example of [Assured Workloads](https://cloud.google.com/assured-workloads/docs/overview) using [Regional Control](https://cloud.google.com/assured-workloads/docs/control-packages#regional-controls), [Cloud Hardware Security Module (HSM) Key](https://cloud.google.com/kms/docs/hsm), and [Key Access Justifications](https://cloud.google.com/assured-workloads/docs/key-access-justifications).

## Prerequisites

These sections describe requirements to run this example.

### Software

Install the following softwares:

- [Google Cloud SDK](https://cloud.google.com/sdk/install)
- [Terraform](https://www.terraform.io/downloads.html)

### Cloud SDK configurations

You must be authenticated in your Google Cloud Platform (GCP) account. Run the commands below to authenticate:

```sh
gcloud auth login
gcloud auth application-default login
```

### Clone the example repository

Clone the respository and go to the example folder:

```sh
git clone git@github.com:GoogleCloudPlatform/kms-solutions.git
cd kms-solutions/examples/assured-workloads-example/
```

### Service Account

To provision the resources in this example you should use a service account.

First, make sure the following APIs are enabled in the project in which the service account will be created:

```sh
export PROJECT_ID=<YOUR-SA-PROJECT-ID>

gcloud services enable \
  iam.googleapis.com \
  cloudbilling.googleapis.com \
  serviceusage.googleapis.com \
  cloudresourcemanager.googleapis.com \
  assuredworkloads.googleapis.com \
  orgpolicy.googleapis.com \
  --project ${PROJECT_ID}
```

Use the commands below to create a [new service account](<https://cloud.google.com/iam/docs/service-accounts-create>):

```sh
export SA=<YOUR-SA-NAME>

gcloud iam service-accounts create ${SA} \
  --description="SA used to provision resources from the Assured Workloads example." \
  --display-name="Assured Workloads Provisioner" \
  --project ${PROJECT_ID}
```

Grant the necessary roles to the service account:

```sh
export ORG_ID=<YOUR-ORG-ID>
export BILLING_ACCOUNT=<YOUR-BILLING-ACCOUNT>
export SA_EMAIL=<YOUR-SA-EMAIL>

gcloud billing accounts add-iam-policy-binding "${BILLING_ACCOUNT}" \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/billing.user"

gcloud organizations add-iam-policy-binding ${ORG_ID} \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/assuredworkloads.editor"

gcloud iam service-accounts add-iam-policy-binding $SA_EMAIL \
  --member="user:$(gcloud auth list --filter="status=ACTIVE" --format="value(account)")" \
  --role="roles/iam.serviceAccountTokenCreator" \
  --project ${PROJECT_ID}
```

## Deploy infrastructure

1. Make sure the service account is set to provision the resources:

```sh
export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$SA_EMAIL
```

1. Rename `terraform.example.tfvars` to `terraform.tfvars`:

  ```sh
  mv terraform.example.tfvars terraform.tfvars
  ```

1. Update `terraform.tfvars` file with the required values.

1. Create the infrastructure.

    ```sh
    terraform init
    terraform apply
    ```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aw\_compliance\_regime | Compliance regime of the workload. You can check the supported values in https://cloud.google.com/assured-workloads/docs/reference/rest/Shared.Types/ComplianceRegime. | `string` | n/a | yes |
| aw\_location | Workload location. | `string` | n/a | yes |
| aw\_name | Base name of the workload. | `string` | n/a | yes |
| billing\_account | The Billing Account ID. | `string` | n/a | yes |
| cryptokey\_allowed\_access\_reasons | The list of allowed reasons for access to this CryptoKey. You can check the supported values in https://cloud.google.com/assured-workloads/key-access-justifications/docs/justification-codes. | `list(string)` | <pre>[<br>  "CUSTOMER_INITIATED_ACCESS",<br>  "MODIFIED_CUSTOMER_INITIATED_ACCESS",<br>  "GOOGLE_INITIATED_SYSTEM_OPERATION",<br>  "MODIFIED_GOOGLE_INITIATED_SYSTEM_OPERATION"<br>]</pre> | no |
| folder\_id | Root folder ID for the workload. | `string` | n/a | yes |
| new\_allowed\_restricted\_services | The list of the restricted services that will be added as allowed. See the list of supported products by control package in https://cloud.google.com/assured-workloads/docs/supported-products. | `list(string)` | <pre>[<br>  "bigquery.googleapis.com",<br>  "bigqueryconnection.googleapis.com",<br>  "bigquerydatapolicy.googleapis.com",<br>  "bigquerydatatransfer.googleapis.com",<br>  "bigquerymigration.googleapis.com",<br>  "bigqueryreservation.googleapis.com",<br>  "bigquerystorage.googleapis.com",<br>  "file.googleapis.com",<br>  "networksecurity.googleapis.com"<br>]</pre> | no |
| org\_id | The Organization ID. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| aw\_id | Assured Workload ID. |
| kms\_key\_id | Crypto Key ID. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
