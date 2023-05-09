resource "yandex_mdb_postgresql_cluster" "postgres" {
  name        = "pg-prometheus-cluster"
  description = "PostgreSQL cluster for Prometheus metrics"
  environment = "PRODUCTION"
  network_id  = yandex_vpc_network.vpc.id
  security_group_ids = [yandex_vpc_security_group.postgres.id]

  config {
    version = 15
    autofailover = true
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 30
    }
    postgresql_config = {
      max_connections                   = 400
      max_locks_per_transaction         = 200
      max_parallel_workers              = 10
      max_prepared_transactions         = 4
      enable_parallel_hash              = true
      autovacuum_vacuum_scale_factor    = 0.34
      default_transaction_isolation     = "TRANSACTION_ISOLATION_READ_COMMITTED"
      shared_preload_libraries          = "SHARED_PRELOAD_LIBRARIES_AUTO_EXPLAIN,SHARED_PRELOAD_LIBRARIES_PG_HINT_PLAN"
    }

  }

  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 12
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.private-db-a.id
  }

  host {
    zone      = "ru-central1-b"
    subnet_id = yandex_vpc_subnet.private-db-b.id
  }
}

resource "yandex_mdb_postgresql_database" "metrics" {
  cluster_id = yandex_mdb_postgresql_cluster.postgres.id
  name       = "metrics"
  owner      = yandex_mdb_postgresql_user.prom.name
  lc_collate = "en_US.UTF-8"
  lc_type    = "en_US.UTF-8"
  extension {
    name = "uuid-ossp"
  }
  extension {
    name = "xml2"
  }
}

resource "yandex_mdb_postgresql_user" "prom" {
  cluster_id = yandex_mdb_postgresql_cluster.postgres.id
  name       = "prom"
  password   = var.pg_admin_password
  conn_limit = 150
  settings = {
    default_transaction_isolation = "read committed"
    log_min_duration_statement    = 5000
  }
}


resource "yandex_vpc_subnet" "private-db-a" {
  name           = "private-db-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["10.1.0.0/24"]
}

resource "yandex_vpc_subnet" "private-db-b" {
  name           = "private-db-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["10.2.0.0/24"]
}