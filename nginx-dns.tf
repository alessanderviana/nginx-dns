variable "region" {
  default = "us-central1"
}
variable "gcp_project" {
  default = "infra-como-codigo-e-automacao"
}
variable "credentials" {
  default = "~/repositorios/terraform/gcloud/credentials.json"
}
variable "vpc_name" {
  default = "default"
}
variable "user" {
  default = "ubuntu"
}
variable "pub_key" {
  default = "~/repositorios/terraform/alessander-tf.pub"
}
variable "priv_key" {
  default = "~/repositorios/terraform/alessander-tf"
}

// Configure the Google Cloud provider
provider "google" {
 credentials = "${file("${var.credentials}")}"
 project     = "${var.gcp_project}"
 region      = "${var.region}"
}

// Linux instance - Ubuntu 16.04
resource "google_compute_instance" "nginx-dns" {
 name         = "nginx-dns"
 machine_type = "f1-micro"  # 0.6 GB RAM
 zone         = "${var.region}-b"

 tags = [ "nginx-dns" ]

 boot_disk {
   initialize_params {
     image = "ubuntu-1604-xenial-v20190306"
   }
 }

 network_interface {
   subnetwork = "default"
   access_config { }
 }

 metadata {
   ssh-keys = "${var.user}:${file("${var.pub_key}")}"
 }

 metadata_startup_script = <<SCRIPT
  curl -fsSL https://get.docker.com/ | bash
  usermod -aG docker ubuntu
SCRIPT

}
