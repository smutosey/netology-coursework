output "external_ip_address_app" {
  value = yandex_alb_load_balancer.cw-netology.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}

output "bastion_external_ip" {
  description = "Public IP address of load bastion."
  #    value = yandex_compute_instance_group.cw-netology.instances.*.network_interface.0.nat_ip_address
  value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
}

output "instances_external_ips" {
  description = "Internal IP address of webservers."
  value       = yandex_compute_instance_group.web-netology.instances.*.network_interface.0.ip_address
}

#output "instances" {
#    description = "webservers."
#    value = yandex_compute_instance_group.web-netology
#}


resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tftpl",
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
