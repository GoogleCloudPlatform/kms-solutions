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

locals {
  service_account_email  = var.service_account == null ? local.custom_sa_email : var.service_account.email
  service_account_scopes = var.service_account == null ? ["https://www.googleapis.com/auth/cloud-platform"] : var.service_account.scopes
}

module "gce-container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 3.0"

  cos_image_name = var.cos_image

  container = {
    image = "${var.artifact_location}-docker.pkg.dev/${var.project_id}/${var.artifact_repository}-${local.default_suffix}/${var.artifact_image}:${var.artifact_version}"
  }

  restart_policy = "Always"
}

resource "google_compute_instance" "vm" {
  project      = var.project_id
  name         = var.hostname
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = module.gce-container.source_image
    }
    mode = "READ_WRITE"
  }

  network_interface {
    subnetwork_project = var.project_id
    subnetwork         = module.vpc.subnets_ids[0]
  }

  tags = ["allow-ssh-iap"]

  metadata = {
    gce-container-declaration = module.gce-container.metadata_value
    google-logging-enabled    = "true"
    google-monitoring-enabled = "true"
  }

  labels = {
    container-vm = module.gce-container.vm_container_label
  }

  service_account {
    email  = local.service_account_email
    scopes = local.service_account_scopes
  }

  depends_on = [null_resource.pkcs11_docker_image_build_template]

}
