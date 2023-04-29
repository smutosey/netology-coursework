resource "yandex_vpc_network" "private" {
  name = "private"
}

resource "yandex_vpc_network" "public" {
  name = "public"
}

resource "yandex_vpc_subnet" "private-a" {
  name           = "private-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.private.id
  v4_cidr_blocks = ["172.16.1.0/24"]
}

resource "yandex_vpc_subnet" "private-b" {
  name           = "private-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.private.id
  v4_cidr_blocks = ["172.16.2.0/24"]
}

resource "yandex_vpc_subnet" "private-c" {
  name           = "private-c"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.private.id
  v4_cidr_blocks = ["172.16.3.0/24"]
}
