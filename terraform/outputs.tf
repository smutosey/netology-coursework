output "external_ip_address_app" {
  value = yandex_alb_load_balancer.cw-netology.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}

output "instances_external_ips" {
    description = "Public IP address of bastion."
    #    value = yandex_compute_instance_group.cw-netology.instances.*.network_interface.0.nat_ip_address
    value = yandex_compute_instance.cw-bastion.network_interface.0.nat_ip_address
}