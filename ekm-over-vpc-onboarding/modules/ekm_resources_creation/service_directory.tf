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

resource "google_service_directory_namespace" "sd_namespace" {
  provider     = google-beta
  namespace_id = "${var.servicedirectory_name}-namespace"
  location     = var.location
  project      = data.google_project.vpc_project.number
}

resource "google_service_directory_service" "sd_service" {
  provider   = google-beta
  service_id = "${var.servicedirectory_name}-service"
  namespace  = google_service_directory_namespace.sd_namespace.id

  metadata = {
    region = var.location
  }
}

resource "google_service_directory_endpoint" "sd_endpoint" {
  provider    = google-beta
  endpoint_id = "${var.servicedirectory_name}-endpoint"
  service     = google_service_directory_service.sd_service.id
  network     = "projects/${data.google_project.vpc_project.number}/locations/global/networks/${module.vpc-network.network_name}"
  address     = var.external_key_manager_ip
  port        = var.external_key_manager_port
}
