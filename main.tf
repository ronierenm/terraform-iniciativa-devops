terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "k8s_iniciativa_devops" {
  name   = "k8s_iniciativa_devops"
  region = "nyc1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.22.8-do.1"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 3
  }
}

# or using -var="do_token=..." CLI option
variable "do_token" {}
variable "k8s_name" {}
variable "region" {}

output "kube_endpoint" {
    value = digitalocean_kubernetes_cluster.k8s_iniciativa_devops.endpoint  
}

resource "local_file" "kube_config" {
    content = digitalocean_kubernetes_cluster.k8s_iniciativa_devops.kube_config.0.raw_config
    filename = kube_config.yaml
  
}