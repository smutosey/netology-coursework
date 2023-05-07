# -------------------------###{{{ WEBSERVERS }}}###--------------------------------

resource "yandex_vpc_security_group_rule" "web-healthchecks" {
  security_group_binding = yandex_vpc_security_group.webservers.id
  direction              = "ingress"
  description            = "LB healthchecks"
  v4_cidr_blocks         = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
  port                   = 80
  protocol               = "TCP"
}

resource "yandex_vpc_security_group_rule" "web-access" {
  security_group_binding = yandex_vpc_security_group.webservers.id
  direction              = "ingress"
  description            = "incoming requests from web app"
  security_group_id      = yandex_vpc_security_group.load-balancer.id
  port                   = 80
  protocol               = "TCP"
}

resource "yandex_vpc_security_group_rule" "web-ssh" {
  security_group_binding = yandex_vpc_security_group.webservers.id
  direction              = "ingress"
  description            = "WEBSERVERS: bastion ssh connection"
  security_group_id      = yandex_vpc_security_group.bastion.id
  port                   = 22
  protocol               = "TCP"
}

resource "yandex_vpc_security_group_rule" "web-node-metrics" {
  security_group_binding = yandex_vpc_security_group.webservers.id
  direction              = "ingress"
  description            = "WEBSERVERS: scrape node metrics"
  security_group_id      = yandex_vpc_security_group.prometheus.id
  port                   = 9100
  protocol               = "TCP"
}

resource "yandex_vpc_security_group_rule" "web-nginx-metrics" {
  security_group_binding = yandex_vpc_security_group.webservers.id
  direction              = "ingress"
  description            = "WEBSERVERS: scrape nginx metrics"
  security_group_id      = yandex_vpc_security_group.prometheus.id
  port                   = 4040
  protocol               = "TCP"
}

resource "yandex_vpc_security_group_rule" "web-egress" {
  security_group_binding = yandex_vpc_security_group.webservers.id
  direction              = "egress"
  description            = "WEBSERVERS: outgoing requests"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  protocol               = "ANY"
}

# -------------------------###{{{ POSTGRES }}}###--------------------------------
resource "yandex_vpc_security_group_rule" "pg-prometheus" {
  security_group_binding = yandex_vpc_security_group.postgres.id
  direction              = "ingress"
  description            = "POSTGRES: incoming requests from Prometheus"
  security_group_id      = yandex_vpc_security_group.prometheus.id
  protocol               = "TCP"
  port                   = 6432
}

# -------------------------###{{{ PROMETHEUS }}}###--------------------------------
resource "yandex_vpc_security_group_rule" "prom-grafana" {
  security_group_binding = yandex_vpc_security_group.prometheus.id
  direction              = "ingress"
  description            = "PROMETHEUS: incoming queries from grafana"
  security_group_id      = yandex_vpc_security_group.grafana.id
  protocol               = "TCP"
  port                   = 9090
}

resource "yandex_vpc_security_group_rule" "prom-ssh" {
  security_group_binding = yandex_vpc_security_group.prometheus.id
  direction              = "ingress"
  description            = "PROMETHEUS: bastion ssh connection"
  security_group_id      = yandex_vpc_security_group.bastion.id
  protocol               = "TCP"
  port                   = 22
}

resource "yandex_vpc_security_group_rule" "prom-egress" {
  security_group_binding = yandex_vpc_security_group.prometheus.id
  direction              = "egress"
  description            = "PROMETHEUS: outgoing requests"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  protocol               = "ANY"
}

# -------------------------###{{{ ELASTIC }}}###--------------------------------
resource "yandex_vpc_security_group_rule" "elastic-kibana" {
  security_group_binding = yandex_vpc_security_group.elasticsearch.id
  direction              = "ingress"
  description            = "ELASTICSEARCH: incoming read queries from kibana"
  security_group_id      = yandex_vpc_security_group.kibana.id
  protocol               = "TCP"
  port                   = 9200
}

resource "yandex_vpc_security_group_rule" "elastic-webservers-logs" {
  security_group_binding = yandex_vpc_security_group.elasticsearch.id
  direction              = "ingress"
  description            = "ELASTICSEARCH: incoming queries from webservers (filebeat)"
  security_group_id      = yandex_vpc_security_group.webservers.id
  protocol               = "TCP"
  port                   = 9200
}

resource "yandex_vpc_security_group_rule" "elastic-prom-logs" {
  security_group_binding = yandex_vpc_security_group.elasticsearch.id
  direction              = "ingress"
  description            = "ELASTICSEARCH: incoming logs from webservers (filebeat)"
  security_group_id      = yandex_vpc_security_group.prometheus.id
  protocol               = "TCP"
  port                   = 9200
}

resource "yandex_vpc_security_group_rule" "elastic-grafana-logs" {
  security_group_binding = yandex_vpc_security_group.elasticsearch.id
  direction              = "ingress"
  description            = "ELASTICSEARCH: incoming logs from grafana (filebeat)"
  security_group_id      = yandex_vpc_security_group.grafana.id
  protocol               = "TCP"
  port                   = 9200
}

resource "yandex_vpc_security_group_rule" "elastic-kibana-logs" {
  security_group_binding = yandex_vpc_security_group.elasticsearch.id
  direction              = "ingress"
  description            = "ELASTICSEARCH: incoming logs from kibana (filebeat)"
  security_group_id      = yandex_vpc_security_group.kibana.id
  protocol               = "TCP"
  port                   = 9200
}

resource "yandex_vpc_security_group_rule" "elastic-node-metrics" {
  security_group_binding = yandex_vpc_security_group.elasticsearch.id
  direction              = "ingress"
  description            = "ELASTICSEARCH: scrape metrics from Prometheus"
  security_group_id      = yandex_vpc_security_group.prometheus.id
  protocol               = "TCP"
  port                   = 9100
}

resource "yandex_vpc_security_group_rule" "elastic-ssh" {
  security_group_binding = yandex_vpc_security_group.elasticsearch.id
  direction              = "ingress"
  description            = "ELASTICSEARCH: bastion ssh connection"
  security_group_id      = yandex_vpc_security_group.bastion.id
  protocol               = "TCP"
  port                   = 22
}

resource "yandex_vpc_security_group_rule" "elastic-egress" {
  security_group_binding = yandex_vpc_security_group.elasticsearch.id
  direction              = "egress"
  description            = "ELASTICSEARCH: outgoing requests"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  protocol               = "ANY"
}

# -------------------------###{{{ GRAFANA }}}###--------------------------------
resource "yandex_vpc_security_group_rule" "grafana-ui-access" {
  security_group_binding = yandex_vpc_security_group.grafana.id
  direction              = "ingress"
  description            = "GRAFANA: UI access"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  protocol               = "ANY"
  port                   = 3000
}

resource "yandex_vpc_security_group_rule" "grafana-node-metrics" {
  security_group_binding = yandex_vpc_security_group.grafana.id
  direction              = "ingress"
  description            = "GRAFANA: scrape metrics to Prometheus"
  security_group_id      = yandex_vpc_security_group.prometheus.id
  protocol               = "TCP"
  port                   = 9100
}

resource "yandex_vpc_security_group_rule" "grafana-ssh" {
  security_group_binding = yandex_vpc_security_group.grafana.id
  direction              = "ingress"
  description            = "GRAFANA: bastion ssh connection"
  security_group_id      = yandex_vpc_security_group.bastion.id
  protocol               = "TCP"
  port                   = 22
}

resource "yandex_vpc_security_group_rule" "grafana-egress" {
  security_group_binding = yandex_vpc_security_group.grafana.id
  direction              = "egress"
  description            = "GRAFANA: outgoing requests"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  protocol               = "ANY"
}

# -------------------------###{{{ KIBANA }}}###--------------------------------
resource "yandex_vpc_security_group_rule" "kibana-ui-access" {
  security_group_binding = yandex_vpc_security_group.kibana.id
  direction              = "ingress"
  description            = "KIBANA: UI access"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  protocol               = "ANY"
  port = 5601
}

resource "yandex_vpc_security_group_rule" "kibana-node-metrics" {
  security_group_binding = yandex_vpc_security_group.kibana.id
  direction              = "ingress"
  description            = "KIBANA: metrics to Prometheus"
  security_group_id      = yandex_vpc_security_group.prometheus.id
  protocol               = "TCP"
  port                   = 9100
}

resource "yandex_vpc_security_group_rule" "kibana-ssh" {
  security_group_binding = yandex_vpc_security_group.kibana.id
  direction              = "ingress"
  description            = "KIBANA: bastion ssh connection"
  security_group_id      = yandex_vpc_security_group.bastion.id
  protocol               = "TCP"
  port                   = 22
}

resource "yandex_vpc_security_group_rule" "kibana-egress" {
  security_group_binding = yandex_vpc_security_group.kibana.id
  direction              = "egress"
  description            = "KIBANA: outgoing requests"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  protocol               = "ANY"
}

# -------------------------###{{{ LOAD BALANCER }}}###--------------------------------
resource "yandex_vpc_security_group_rule" "lb-access" {
  security_group_binding = yandex_vpc_security_group.load-balancer.id
  direction              = "ingress"
  description            = "LB: incoming requests from web"
  v4_cidr_blocks = ["0.0.0.0/0"]
  port                   = 443
  protocol               = "TCP"
}

resource "yandex_vpc_security_group_rule" "lb-healthchecks" {
  security_group_binding = yandex_vpc_security_group.load-balancer.id
  direction              = "ingress"
  description            = "LB: healthchecks"
  predefined_target = "loadbalancer_healthchecks"
  port                   = 30080
  protocol               = "TCP"
}

resource "yandex_vpc_security_group_rule" "lb-egress" {
  security_group_binding = yandex_vpc_security_group.load-balancer.id
  direction              = "egress"
  description            = "KIBANA: outgoing requests"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  protocol               = "ANY"
}

# -------------------------###{{{ BASTION }}}###--------------------------------
resource "yandex_vpc_security_group_rule" "bastion-ssh" {
  security_group_binding = yandex_vpc_security_group.bastion.id
  direction              = "ingress"
  description            = "BASTION: allow SSH access from Internet"
  v4_cidr_blocks = ["0.0.0.0/0"]
  protocol               = "TCP"
  port                   = 22
}

resource "yandex_vpc_security_group_rule" "bastion-egress" {
  security_group_binding = yandex_vpc_security_group.bastion.id
  direction              = "egress"
  description            = "BASTION: outgoing requests"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  protocol               = "ANY"
}


