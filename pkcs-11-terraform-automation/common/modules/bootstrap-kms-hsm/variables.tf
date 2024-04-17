/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "suffix" {
  description = "A suffix to be used as an identifier for resources. (e.g., suffix for KMS Key, Keyring, SAs, etc.)."
  type        = string
}

variable "project_id" {
  description = "GCP project ID to use for the creation of resources."
  type        = string
}

variable "location" {
  description = "Location for the resources (keyring, key, network, etc.)."
  type        = string
}

variable "keyring" {
  description = "Keyring name."
  type        = string
}

variable "key" {
  description = "Key name."
  type        = string
}

variable "prevent_destroy" {
  description = "Set the prevent_destroy lifecycle attribute on keys."
  type        = bool
}

variable "network_name" {
  description = "VPC network name."
  type        = string
  default     = "custom-hsm-network"
}

variable "subnetwork_name" {
  description = "VPC subnetwork name."
  type        = string
  default     = "custom-hsm-subnetwork"
}

variable "organization_id" {
  description = "GCP organization ID that will used to apply desired Org Policies. If not provided, Org Policies won't be applied."
  type        = string
  default     = ""
}

variable "region" {
  description = "GCP region to use for the creation of resources."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone to use for the creation of resources."
  type        = string
  default     = "us-central1-a"
}

variable "hostname" {
  description = "Name of the VM host."
  type        = string
}

variable "machine_type" {
  description = "Type of the GCE VM."
  type        = string
  default     = "n1-standard-1"
}

variable "cos_image" {
  description = "Custom OS image desired for the VM."
  type        = string
  default     = "cos-stable-109-17800-66-57"
}

variable "service_account" {
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template#service_account."
  type = object({
    email  = string,
    scopes = set(string)
  })
  default = null
}

variable "artifact_location" {
  description = "Location's name of the image stored in Artifact Registry."
  type        = string
}

variable "artifact_version" {
  description = "Version of the image stored in Artifact Registry."
  type        = string
}

variable "artifact_repository" {
  description = "Respository's name of the image stored in Artifact Registry."
  type        = string
}

variable "artifact_image" {
  description = "Image's name stored in Artifact Registry."
  type        = string
}

variable "pkcs11_lib_version" {
  description = "Version of the PKCS #11 library version. To see more info about versions available: https://github.com/GoogleCloudPlatform/kms-integrations/releases?q=pkcs%2311&expanded=true"
  type        = string
}

variable "certificate_file_path" {
  description = "Certificate file path to be used on sign process. This should be used when you have a certificate file signed by a Certificate Authority. If not provided, a self-signed certificate will be generated with OpenSSL. Use self-signed certificate for testing only. A self-signed certificate created this way is not appropriate for production use."
  type        = string
  default     = null
}

variable "digest_flag" {
  description = "A flag indicating the type of digest. Use sha256, sha384, or sha512 depending on the algorithm of the key."
  type        = string
  default     = "sha256"
}

variable "certificate_name" {
  description = "A name for the certificate that you want to generate. This will be used on CN parameter for certificate signing requests or/and self-signed certificates."
  type        = string
  default     = "TERRAFORM_CERT"
}

variable "docker_file_path" {
  description = "The Dockerfile path."
  type        = string
  default     = "./"
}
