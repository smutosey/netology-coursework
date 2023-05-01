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