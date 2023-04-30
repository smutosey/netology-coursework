resource "yandex_vpc_security_group" "webservers-sg" {
  name        = "webserverssg"
  description = "Webservers security group"
  network_id  = yandex_vpc_network.cw-network.id

  ingress {
    protocol       = "TCP"
    description    = "Rule1 for healthchecks"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 1
    to_port        = 32767
  }

  ingress {
    protocol       = "TCP"
    description    = "Rule for load balancer"
    security_group_id = yandex_vpc_security_group.loadbalancer.id
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "Rule for bastion ssh"
    security_group_id = yandex_vpc_security_group.bastion.id
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "Rule1 for metrics"
    security_group_id = yandex_vpc_security_group.prometheus-sg.id
    port           = 9100
  }

  ingress {
    protocol       = "TCP"
    description    = "Rule2 for metrics"
    security_group_id = yandex_vpc_security_group.prometheus-sg.id
    port           = 4040
  }

  egress {
    protocol       = "ANY"
    description    = "Rule out"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "prometheus-sg" {
  name        = "prometheussg"
  description = "Prometheus security group"
  network_id  = yandex_vpc_network.cw-network.id

  ingress {
    protocol       = "TCP"
    description    = "Rule for grafana"
    security_group_id = yandex_vpc_security_group.grafana-sg.id
    port           = 9090
  }

  ingress {
    protocol       = "TCP"
    description    = "Rule for bastion ssh"
    security_group_id = yandex_vpc_security_group.bastion.id
    port           = 22
  }

  egress {
    protocol       = "ANY"
    description    = "Rule out"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "elasticsearch-sg" {
  name        = "elasticsearchsg"
  description = "Elasticsearch security group"
  network_id  = yandex_vpc_network.cw-network.id

  ingress {
    protocol       = "TCP"
    description    = "Rule for kibana"
    security_group_id = yandex_vpc_security_group.kibana-sg.id
    port           = 9200
  }

  ingress {
    protocol       = "TCP"
    description    = "Rule for webservers"
    security_group_id = yandex_vpc_security_group.webservers-sg.id
    port           = 9200
  }

  ingress {
    protocol       = "TCP"
    description    = "Rule for bastion ssh"
    security_group_id = yandex_vpc_security_group.bastion.id
    port           = 22
  }

  egress {
    protocol       = "ANY"
    description    = "Rule out"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "grafana-sg" {
  name        = "grafanasg"
  description = "Grafana security group"
  network_id  = yandex_vpc_network.cw-network.id

  ingress {
    protocol       = "TCP"
    description    = "Rule for all"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 3000
  }

  ingress {
    protocol       = "TCP"
    description    = "Rule for bastion ssh"
    security_group_id = yandex_vpc_security_group.bastion.id
    port           = 22
  }

  egress {
    protocol       = "ANY"
    description    = "Rule out"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "kibana-sg" {
  name        = "kibanasg"
  description = "Kibana security group"
  network_id  = yandex_vpc_network.cw-network.id

  ingress {
    protocol       = "TCP"
    description    = "Rule for all"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 5601
  }

  ingress {
    protocol       = "TCP"
    description    = "Rule for bastion ssh"
    security_group_id = yandex_vpc_security_group.bastion.id
    port           = 22
  }

  egress {
    protocol       = "ANY"
    description    = "Rule out"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "loadbalancer" {
  name        = "loadbalancer1sg"
  description = "Load balancer security group"
  network_id  = yandex_vpc_network.cw-network.id

  ingress {
    protocol       = "TCP"
    description    = "Rule for income"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "Rule1 for healthchecks"
    v4_cidr_blocks = ["198.18.235.0/24"]
    from_port      = 1
    to_port        = 32767
  }

  ingress {
    protocol       = "TCP"
    description    = "Rule2 for healthchecks"
    v4_cidr_blocks = ["198.18.248.0/24"]
    from_port      = 1
    to_port        = 32767
  }
  
  egress {
    protocol       = "ANY"
    description    = "Rule out"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "bastion" {
  name        = "Bastionsg"
  description = "Bastion security group"
  network_id  = yandex_vpc_network.cw-network.id

  ingress {
    protocol       = "TCP"
    description    = "Rule for income"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  egress {
    protocol       = "ANY"
    description    = "Rule out"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}  