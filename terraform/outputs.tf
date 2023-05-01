output "external_ip_address_app" {
  value = yandex_alb_load_balancer.cw-netology.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}

output "bastion_external_ip" {
    description = "Public IP address of load bastion."
    #    value = yandex_compute_instance_group.cw-netology.instances.*.network_interface.0.nat_ip_address
    value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
}

output "instances_external_ips" {
    description = "Public IP address of bastion."
    value = yandex_compute_instance_group.web-netology.instances.*.network_interface.0.ip_address
}

resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tftpl",
    {
      bastion       = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
      webservers    = [for instance in yandex_compute_instance_group.web-netology.instances: instance.network_interface.0.ip_address]
      prometheus    = yandex_compute_instance.prometheus.network_interface.0.ip_address
      grafana       = yandex_compute_instance.grafana.network_interface.0.ip_address
      elastic       = yandex_compute_instance.elastic.network_interface.0.ip_address
      kibana        = yandex_compute_instance.kibana.network_interface.0.ip_address

    }
  )
  filename = "../ansible/inventory.yaml"
}

resource "local_file" "hosts_ini" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      webservers    = [for p in yandex_compute_instance.webserver: p.network_interface.0.ip_address]
      prometheus    = yandex_compute_instance.prometheusnetwork_interface.*.ip_address
      grafana       = yandex_compute_instance.vm-4.network_interface.*.ip_address
      elastic       = yandex_compute_instance.vm-5.network_interface.*.ip_address
      kibana        = yandex_compute_instance.vm-6.network_interface.*.ip_address
      bastion       = yandex_compute_instance.vm-7.network_interface.0.nat_ip_address
    }
  )
  filename = "../ansible/inventory/hosts.ini"
}