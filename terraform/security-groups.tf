resource "yandex_vpc_security_group" "webservers" {
  name        = "webservers"
  description = "Webservers security group"
  network_id  = yandex_vpc_network.vpc.id

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
    security_group_id = yandex_vpc_security_group.load-balancer.id
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
    security_group_id = yandex_vpc_security_group.prometheus.id
    port           = 9100
  }

  ingress {
    protocol       = "TCP"
    description    = "Rule2 for metrics"
    security_group_id = yandex_vpc_security_group.prometheus.id
    port           = 4040
  }

  egress {
    protocol       = "ANY"
    description    = "Rule out"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "prometheus" {
  name        = "prometheus"
  description = "Prometheus security group"
  network_id  = yandex_vpc_network.vpc.id

  ingress {
    protocol       = "TCP"
    description    = "Rule for grafana"
    security_group_id = yandex_vpc_security_group.grafana.id
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

resource "yandex_vpc_security_group" "elasticsearch" {
  name        = "elasticsearch"
  description = "Elasticsearch security group"
  network_id  = yandex_vpc_network.vpc.id

  ingress {
    protocol       = "TCP"
    description    = "Rule for kibana"
    security_group_id = yandex_vpc_security_group.kibana.id
    port           = 9200
  }

  ingress {
    protocol       = "TCP"
    description    = "Rule for webservers"
    security_group_id = yandex_vpc_security_group.webservers.id
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

resource "yandex_vpc_security_group" "grafana" {
  name        = "grafana"
  description = "Grafana security group"
  network_id  = yandex_vpc_network.vpc.id

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

resource "yandex_vpc_security_group" "kibana" {
  name        = "kibana"
  description = "Kibana security group"
  network_id  = yandex_vpc_network.vpc.id

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

resource "yandex_vpc_security_group" "load-balancer" {
  name        = "load-balancer"
  description = "Load balancer security group"
  network_id  = yandex_vpc_network.vpc.id

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
  name        = "external-bastion"
  description = "external bastion security group"
  network_id  = yandex_vpc_network.vpc.id

  ingress {
    protocol       = "TCP"
    description    = "allow SSH access from Internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  egress {
    protocol       = "ANY"
    description    = "Rule out"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

