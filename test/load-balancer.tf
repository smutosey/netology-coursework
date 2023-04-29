resource "yandex_alb_backend_group" "netology-backend-group" {
  name = "netology-backend-group"

  http_backend {
    name             = "netology-http-backend"
    weight           = 1
    port             = 8080
    target_group_ids = [yandex_compute_instance_group.ig-netology-web.application_load_balancer.0.target_group_id]
    load_balancing_config {
      panic_threshold = 50
    }
    healthcheck {
      timeout  = "1s"
      interval = "1s"
      healthcheck_port = 80
      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "netology-router" {
  name   = "netology-http-router"
}

resource "yandex_alb_virtual_host" "netology-virtual-host" {
  name           = "netology-virtual-host"
  http_router_id = yandex_alb_http_router.netology-router.id
  route {
    name = "socketio"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.netology-backend-group.id
        timeout          = "3s"
        upgrade_types    = ["websocket"]
      }
    }
  }
}

resource "yandex_alb_load_balancer" "netology-balancer" {
  name = "netology-alb"

  network_id = yandex_vpc_network.private.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.private-a.id
    }
    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.private-b.id
    }
    location {
      zone_id   = "ru-central1-c"
      subnet_id = yandex_vpc_subnet.private-c.id
    }
  }

  listener {
    name = "socket-io"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.netology-router.id
      }
    }
  }
}