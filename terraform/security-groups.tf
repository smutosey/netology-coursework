resource "yandex_vpc_security_group" "webservers" {
  name        = "webservers"
  description = "Webservers security group"
  network_id  = yandex_vpc_network.vpc.id
}

resource "yandex_vpc_security_group" "postgres" {
  name       = "postgres"
  network_id = yandex_vpc_network.vpc.id
}

resource "yandex_vpc_security_group" "prometheus" {
  name        = "prometheus"
  description = "Prometheus security group"
  network_id  = yandex_vpc_network.vpc.id
}

resource "yandex_vpc_security_group" "elasticsearch" {
  name        = "elasticsearch"
  description = "Elasticsearch security group"
  network_id  = yandex_vpc_network.vpc.id
}

resource "yandex_vpc_security_group" "grafana" {
  name        = "grafana"
  description = "Grafana security group"
  network_id  = yandex_vpc_network.vpc.id
}

resource "yandex_vpc_security_group" "kibana" {
  name        = "kibana"
  description = "Kibana security group"
  network_id  = yandex_vpc_network.vpc.id
}

resource "yandex_vpc_security_group" "load-balancer" {
  name        = "load-balancer"
  description = "Load balancer security group"
  network_id  = yandex_vpc_network.vpc.id
}

resource "yandex_vpc_security_group" "bastion" {
  name        = "external-bastion"
  description = "external bastion security group"
  network_id  = yandex_vpc_network.vpc.id
}