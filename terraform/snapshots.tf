data "yandex_compute_instance" "ig_instances" {
  for_each = toset(yandex_compute_instance_group.web-netology.instances.*.instance_id)
  instance_id = each.value

  depends_on = [
    yandex_compute_instance_group.web-netology
  ]
}


resource "yandex_compute_snapshot_schedule" "default" {
  name           = "cw-snapshots"

  schedule_policy {
    expression = "0 0 * * *"
  }
  retention_period = "168h0m0s"

  snapshot_spec {
      description = "coursework-snapshots"
      labels = {
        snapshot-label = "netology"
      }
  }

  labels = {
    my-label = "netology-schedule"
  }

  disk_ids = concat(
    [for instance in data.yandex_compute_instance.ig_instances : instance.boot_disk[0].disk_id],
    [yandex_compute_instance.prometheus.boot_disk[0].disk_id],
    [yandex_compute_instance.elastic.boot_disk[0].disk_id],
    [yandex_compute_instance.grafana.boot_disk[0].disk_id],
    [yandex_compute_instance.kibana.boot_disk[0].disk_id]
  )

  depends_on = [
    yandex_compute_instance_group.web-netology
  ]
}