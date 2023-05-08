data "yandex_compute_image" "base" {
  family = "debian-11"
}

data "yandex_compute_image" "webserver" {
  family = "lemp"
}

resource "yandex_compute_instance" "bastion" {
  name               = "bastion"
  hostname           = "bastion"
  zone               = var.app_instance_zone
  folder_id          = var.yc_folder_id
  service_account_id = yandex_iam_service_account.dude.id
  description        = "bastion"
  platform_id        = "standard-v3"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.base.id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.bastion.id
    nat                = true
    ip_address         = "192.168.99.99"
    security_group_ids = [yandex_vpc_security_group.bastion.id]
  }

  metadata = {
    user-data = file("./meta/default.yaml")
  }
}

resource "yandex_compute_instance" "prometheus" {
  name               = "prometheus"
  hostname           = "prometheus"
  zone               = var.app_instance_zone
  folder_id          = var.yc_folder_id
  service_account_id = yandex_iam_service_account.dude.id
  description        = "prometheus"
  platform_id        = "standard-v3"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.base.id
      size     = 20
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private-observability.id
    security_group_ids = [yandex_vpc_security_group.prometheus.id]
  }

  metadata = {
    user-data = file("./meta/default.yaml")
  }
}

resource "yandex_compute_instance" "elastic" {
  name               = "elastic"
  hostname           = "elastic"
  zone               = var.app_instance_zone
  folder_id          = var.yc_folder_id
  service_account_id = yandex_iam_service_account.dude.id
  description        = "elasticsearch"
  platform_id        = "standard-v3"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.base.id
      size     = 20
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private-observability.id
    security_group_ids = [yandex_vpc_security_group.elasticsearch.id]
  }

  metadata = {
    user-data = file("./meta/default.yaml")
  }
}

resource "yandex_compute_instance" "grafana" {
  name               = "grafana"
  hostname           = "grafana"
  zone               = var.app_instance_zone
  folder_id          = var.yc_folder_id
  service_account_id = yandex_iam_service_account.dude.id
  description        = "grafana + alertmanager"
  platform_id        = "standard-v3"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.base.id
      size     = 20
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.grafana.id]
  }

  metadata = {
    user-data = file("./meta/default.yaml")
  }
}

resource "yandex_compute_instance" "kibana" {
  name               = "kibana"
  hostname           = "kibana"
  zone               = var.app_instance_zone
  folder_id          = var.yc_folder_id
  service_account_id = yandex_iam_service_account.dude.id
  description        = "kibana"
  platform_id        = "standard-v3"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.base.id
      size     = 20
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.kibana.id]
  }

  metadata = {
    user-data = file("./meta/default.yaml")
  }
}

resource "yandex_compute_instance_group" "web-netology" {
  name                = "web-netology"
  folder_id           = var.yc_folder_id
  service_account_id  = yandex_iam_service_account.dude.id
  deletion_protection = false

  application_load_balancer {
    target_group_name = "cw-netology"
  }

  instance_template {
    platform_id        = "standard-v3"
    name               = "webserver-{instance.short_id}"
    hostname           = "webserver-{instance.short_id}"
    service_account_id = yandex_iam_service_account.dude.id
    resources {
      cores         = 2
      memory        = 1
      core_fraction = 20
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = data.yandex_compute_image.webserver.id
        size     = "20"
        type     = "network-hdd"
      }
    }

    network_interface {
      network_id         = yandex_vpc_network.vpc.id
      subnet_ids         = [yandex_vpc_subnet.private-web-a.id, yandex_vpc_subnet.private-web-b.id, yandex_vpc_subnet.private-web-c.id]
      ipv6               = false
      security_group_ids = [yandex_vpc_security_group.webservers.id]
    }

    metadata = {
      user-data = file("meta/default.yaml")
    }
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
    max_expansion   = 1
    max_deleting    = 2
    max_creating    = 3
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_binding.editor
  ]
}