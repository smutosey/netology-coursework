resource "yandex_vpc_network" "cw-network" {
  name = "cw-network"
}

resource "yandex_vpc_gateway" "cw-private-gateway" {
  name = "cw-private-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "vpc_route" {
  name       = "vpc_route"
  network_id = yandex_vpc_network.cw-network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.cw-private-gateway.id
  }
}

resource "yandex_vpc_subnet" "private-a" {
  name           = "private-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.cw-network.id
  v4_cidr_blocks = ["192.168.1.0/24"]
  route_table_id = yandex_vpc_route_table.vpc_route.id
}

resource "yandex_vpc_subnet" "private-b" {
  name           = "private-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.cw-network.id
  v4_cidr_blocks = ["192.168.2.0/24"]
  route_table_id = yandex_vpc_route_table.vpc_route.id
}

resource "yandex_vpc_subnet" "private-c" {
  name           = "private-c"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.cw-network.id
  v4_cidr_blocks = ["192.168.3.0/24"]
  route_table_id = yandex_vpc_route_table.vpc_route.id
}

resource "yandex_vpc_subnet" "private-mon" {
  name           = "private-mon"
  zone           = var.app_instance_zone
  network_id     = yandex_vpc_network.cw-network.id
  v4_cidr_blocks = ["192.168.4.0/24"]
  route_table_id = yandex_vpc_route_table.vpc_route.id
}

resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = var.app_instance_zone
  network_id     = yandex_vpc_network.cw-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
