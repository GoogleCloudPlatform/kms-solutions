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

#Network & Subnet creation
module "vpc-network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 9.0"
  project_id   = var.vpc_project_id
  network_name = var.network_name
  mtu          = 1460
  routing_mode = "REGIONAL"

  subnets = [
    {
      subnet_name           = "${var.network_name}-subnet"
      subnet_region         = var.location
      subnet_ip             = var.subnet_ip_cidr_range
      subnet_private_access = true
    }
  ]
}

module "firewall_rules" {
  source  = "terraform-google-modules/network/google//modules/firewall-rules"
  version = "9.1.0"

  project_id   = var.vpc_project_id
  network_name = module.vpc-network.network_name

  rules = [{
    name          = "google-ingress-firewall"
    direction     = "INGRESS"
    source_ranges = ["35.199.192.0/19"]
    allow = [{
      protocol = "tcp"
      ports    = ["80", "31234", "443"]
    }]
    },
    {
      name               = "google-egress-firewall"
      direction          = "EGRESS"
      destination_ranges = ["35.199.192.0/19"]
      allow = [{
        protocol = "all"
      }]
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
  }]
}
