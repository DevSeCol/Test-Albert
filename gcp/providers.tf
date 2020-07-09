terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "servian-melbourne"

    workspaces {
      name = "devsecol"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = "${var.region}-b"
}