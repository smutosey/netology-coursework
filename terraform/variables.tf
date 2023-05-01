variable "ansible_workdir" {
  type = string
  #  description = "Path to Ansible workdir where provisioner tasks are located (i.e. ../ansible)"
}
variable "yc_region" {
  type        = string
  description = "Yandex Cloud Region (i.e. ru-central1-a)"
  default     = "ru-central1-a"
}
variable "yc_cloud_id" {
  type        = string
  description = "Yandex Cloud id"
}
variable "yc_folder_id" {
  type        = string
  description = "Yandex Cloud folder id"
}

#variable yc_public_key_path {
#  description = "public key for ssh"
#}

variable "app_instance_zone" {
  description = "Zone for public servers"
  default     = "ru-central1-b"
}
