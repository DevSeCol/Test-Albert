resource "google_container_cluster" "primary-cluster" {
  name                     = var.cluster_name
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  #network                  = var.cluster_network
  #subnetwork               = var.cluster_subnetwork
}

resource "google_container_node_pool" "preemptible_nodes" {
  name       = "primary-pool"
  location   = google_container_cluster.primary-cluster.location
  cluster    = google_container_cluster.primary-cluster.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    #service_account = var.service_account

    labels = {
      machine-type = "preemtible"
    }

    tags = ["spark-cluster"]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
