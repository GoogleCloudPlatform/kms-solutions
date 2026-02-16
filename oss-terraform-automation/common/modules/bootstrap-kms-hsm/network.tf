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

module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 15.0"
  project_id   = var.project_id
  network_name = "${var.network_name}-${local.default_suffix}"
  mtu          = 1460

  subnets = [
    {
      subnet_name           = "${var.subnetwork_name}-${split("-", split("/", path.cwd)[length(split("/", path.cwd)) - 1])[1]}"
      subnet_ip             = "10.0.0.0/24"
      subnet_region         = var.region
      subnet_private_access = "true"
    }
  ]

  depends_on = [time_sleep.enable_projects_apis_sleep]
}

resource "google_compute_firewall" "allow-ssh-iap" {
  project       = var.project_id
  name          = "fw-allow-iap-${local.default_suffix}"
  network       = module.vpc.network_id
  description   = "Creates firewall rule targeting tagged instances to allow IAP connections"
  direction     = "INGRESS"
  source_ranges = ["35.235.240.0/20"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["allow-ssh-iap"]
}
