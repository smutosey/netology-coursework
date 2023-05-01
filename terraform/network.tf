resource "yandex_vpc_network" "vpc" {
  name = "coursework vpc network"
}

resource "yandex_vpc_gateway" "cw-private-gateway" {
  name = "cw-private-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "vpc_route" {
  name       = "vpc_route"
  network_id = yandex_vpc_network.vpc.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.cw-private-gateway.id
  }
}

resource "yandex_vpc_subnet" "private-web-a" {
  name           = "private-web-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.1.0/24"]
  route_table_id = yandex_vpc_route_table.vpc_route.id
}

resource "yandex_vpc_subnet" "private-web-b" {
  name           = "private-web-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.2.0/24"]
  route_table_id = yandex_vpc_route_table.vpc_route.id
}

resource "yandex_vpc_subnet" "private-web-c" {
  name           = "private-web-c"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.3.0/24"]
  route_table_id = yandex_vpc_route_table.vpc_route.id
}

resource "yandex_vpc_subnet" "private-observability" {
  name           = "private-observability"
  zone           = var.app_instance_zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.4.0/24"]
  route_table_id = yandex_vpc_route_table.vpc_route.id
}

resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = var.app_instance_zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "bastion" {
  name           = "bastion"
  zone           = var.app_instance_zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.99.0/24"]
}
