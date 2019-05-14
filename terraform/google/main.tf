provider "google" {
  credentials = "${file("~/.google/credentials_db_migration.json")}"
  project = "divine-booking-240516"
  region = "europe-west3"
  zone = "europe-west3-a"
}

resource "google_container_cluster" "db_migration_cluster" {
  name = "db-migration-cluster"

  initial_node_count = 1

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""
  }

  node_config {
    machine_type = "g1-small"
  }

}

# The following outputs allow authentication and connectivity to the GKE Cluster
# by using certificate-based authentication.
output "client_certificate" {
  value = "${google_container_cluster.db_migration_cluster.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.db_migration_cluster.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.db_migration_cluster.master_auth.0.cluster_ca_certificate}"
}