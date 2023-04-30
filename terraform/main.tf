provider "yandex" {
  cloud_id                 = var.yc_cloud_id
  folder_id                = var.yc_folder_id
  zone                     = var.yc_region
}

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.47.0"
}

#module "app" {
#  source          = "./modules/app"
#  public_key_path = var.public_key_path
#  app_disk_image  = var.app_disk_image
#  subnet_id       = var.subnet_id
#}