#resource "yandex_iam_service_account" "nedorezov" {
#  name        = "nedorezov"
#  description = "service account"
#}

#resource "yandex_resourcemanager_folder_iam_member" "editor" {
#  folder_id = "b1g36j4atdpik0n1fbjo"
#  role      = "editor"
#  member   = "serviceAccount:${yandex_iam_service_account.nedorezov.id}"
#}

variable "ansible_workdir" {
  type = string
#  description = "Path to Ansible workdir where provisioner tasks are located (i.e. ../ansible)"
}
variable "yc_region" {
  type = string
  description = "Yandex Cloud Region (i.e. ru-central1-a)"
}
variable "yc_cloud_id" {
  type = string
  description = "Yandex Cloud id"
}
variable "yc_folder_id" {
  type = string
  description = "Yandex Cloud folder id"
}

#-----
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

# Provider
provider "yandex" {
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_region
}


# terraform apply -var-file="my.tfvars"