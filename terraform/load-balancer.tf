resource "yandex_alb_http_router" "cw-netology" {
  name = "cw-netology"
  labels = {
    tf-label = "cw-netology"
  }
}

resource "yandex_alb_backend_group" "cw-netology" {
  name = "cw-netology"

  http_backend {
    name             = "test-http-backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_compute_instance_group.web-netology.application_load_balancer[0].target_group_id]
    # tls {
    #   sni = "backend-domain.internal"
    # }
    load_balancing_config {
      panic_threshold = 5
    }
    healthcheck {
      timeout          = "2s"
      interval         = "2s"
      healthcheck_port = 80
      http_healthcheck {
        path = "/"
      }
    }
    #    http2 = "false"
  }
}

resource "yandex_alb_virtual_host" "cw-netology" {
  name           = "cw-netology"
  http_router_id = yandex_alb_http_router.cw-netology.id
  route {
    name = "http"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.cw-netology.id
        timeout          = "3s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "cw-netology" {
  name = "cw-netology"
  network_id = yandex_vpc_network.vpc.id
  security_group_ids = [yandex_vpc_security_group.load-balancer.id]

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.private-web-a.id
    }

    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.private-web-b.id
    }

    location {
      zone_id   = "ru-central1-c"
      subnet_id = yandex_vpc_subnet.private-web-c.id
    }
  }

  listener {
    name = "alb-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
#        internal_ipv4_address {
#          subnet_id = yandex_vpc_subnet.public.id
#        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.cw-netology.id
      }
    }
  }
}