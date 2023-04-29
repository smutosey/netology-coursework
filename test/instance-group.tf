data "yandex_compute_image" "centos" {
  family    = "centos-7"
}

resource "yandex_compute_instance_group" "ig-netology-web" {
  name               = "ig-netology-web"
  service_account_id = yandex_iam_service_account.dude.id

  instance_template {
    platform_id = "standard-v3"
    resources {
      memory = 2
      cores  = 2
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = data.yandex_compute_image.centos.id
        size = 10
      }
    }
    network_interface {
      network_id = yandex_vpc_network.private.id
      subnet_ids = [yandex_vpc_subnet.private-a.id, yandex_vpc_subnet.private-b.id, yandex_vpc_subnet.private-c.id]
      nat = true
    }

    metadata = {
#      а точно ли можно здесь всё уместить? key-value найти
       user-data = file("meta.yaml")
    }
    service_account_id = yandex_iam_service_account.dude.id
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
  }

  deploy_policy {
    max_unavailable = 1
    max_creating    = 1
    max_expansion   = 1
    max_deleting    = 1
  }

  application_load_balancer {
    target_group_name = "netology-tg"
  }
}
