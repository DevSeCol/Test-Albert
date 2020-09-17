resource "google_container_cluster" "primary-cluster" {
  name                     = var.cluster_name
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  #network                  = var.cluster_network
  #subnetwork               = var.cluster_subnetwork
}

resource "google_compute_autoscaler" "autoscaler-first" {
  name   = "my-autoscaler"
  zone   = var.region 
  #target = google_compute_instance_group_manager.foobar.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}

resource "google_container_node_pool" "preemptible_nodes" {
  name       = "primary-pool-albert"
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

    tags = ["test-albert"]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
