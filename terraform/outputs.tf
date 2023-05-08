output "external_ip_address_app" {
  value = yandex_alb_load_balancer.cw-netology.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}

output "bastion_external_ips" {
  description = "Public IP address of load bastion."
  #    value = yandex_compute_instance_group.cw-netology.instances.*.network_interface.0.nat_ip_address
  value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
}

output "internal_instances_ips" {
  description = "Internal IP address of webservers."
  value       = {
    webservers = yandex_compute_instance_group.web-netology.instances.*.network_interface.0.ip_address
    prometheus = yandex_compute_instance.prometheus.network_interface.0.ip_address
    elasticsearch = yandex_compute_instance.elastic.network_interface.0.ip_address
    kibana = yandex_compute_instance.kibana.network_interface.0.ip_address
    grafana = yandex_compute_instance.grafana.network_interface.0.ip_address
  }
}

output "external_instances_ip" {
  description = "Internal IP address of webservers."
  value       = {
    "bastion" = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
    "kibana" = "http://${yandex_compute_instance.kibana.network_interface.0.nat_ip_address}:5601"
    "grafana" = "http://${yandex_compute_instance.grafana.network_interface.0.nat_ip_address}:3000"
    "load_balancer" = "https://${yandex_alb_load_balancer.cw-netology.listener.0.endpoint.0.address.0.external_ipv4_address.0.address}"
    "load_balancer_dns" = "https://netology-web.duckdns.org/"
  }
}

output "pg_cluster_id" {
  value = yandex_mdb_postgresql_cluster.postgres.id
}

resource "local_file" "tf_ansible_vars_file" {
  content = <<-DOC
    pg_cluster_id: ${yandex_mdb_postgresql_cluster.postgres.id}
    pg_admin_password: ${var.pg_admin_password}
    webserver_node_1: ${yandex_compute_instance_group.web-netology.instances.0.name}
    webserver_node_2: ${yandex_compute_instance_group.web-netology.instances.1.name}
    webserver_node_3: ${yandex_compute_instance_group.web-netology.instances.2.name}
    kibana_password: ${var.kibana_password}
    ansible_workdir: ${var.ansible_workdir}
    telegram_bot_token: ${var.telegram_bot_token}
    telegram_chat_id: "${var.telegram_chat_id}"
    DOC
  filename = "../ansible/vars/terraform_vars.yml"
}


resource "local_file" "inventory" {
  content = templatefile("${path.module}/templates/inventory.tftpl",
    {
      bastion = tomap({
        "ip"       = yandex_compute_instance.bastion.network_interface.0.nat_ip_address,
        "hostname" = yandex_compute_instance.bastion.hostname
      })
      webservers = [for instance in yandex_compute_instance_group.web-netology.instances.* : tomap({
        "ip"       = instance.network_interface.0.ip_address,
        "hostname" = instance.name
      })]
      prometheus = tomap({
        "ip"       = yandex_compute_instance.prometheus.network_interface.0.ip_address,
        "hostname" = yandex_compute_instance.prometheus.hostname
      })
      grafana = tomap({
        "ip"       = yandex_compute_instance.grafana.network_interface.0.ip_address,
        "hostname" = yandex_compute_instance.grafana.hostname
      })
      elastic = tomap({
        "ip"       = yandex_compute_instance.elastic.network_interface.0.ip_address,
        "hostname" = yandex_compute_instance.elastic.hostname
      })
      kibana = tomap({
        "ip"       = yandex_compute_instance.kibana.network_interface.0.ip_address,
        "hostname" = yandex_compute_instance.kibana.hostname
      })
    }
  )
  filename = "../ansible/inventory.yaml"
}

