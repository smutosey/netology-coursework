#resource "yandex_compute_snapshot" "bastion" {
#  name           = "bastion-snapshot"
#  source_disk_id = yandex_compute_instance.bastion.boot_disk.disk_id
#
#  labels = {
#    vm = yandex_compute_instance.bastion.hostname
#    id = yandex_compute_instance..id
#  }
#}

resource "yandex_compute_snapshot_schedule" "default" {
  name           = "cw-snapshots"

  schedule_policy {
    expression = "0 0 * * *"
  }
  retention_period = 7

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
    [for instance in yandex_compute_instance_group.web-netology.instances: instance.boot_disk[0].disk_id],
    yandex_compute_instance.prometheus.boot_disk[0].disk_id,
    yandex_compute_instance.bastion.boot_disk[0].disk_id,
    yandex_compute_instance.elastic.boot_disk[0].disk_id,
    yandex_compute_instance.grafana.boot_disk[0].disk_id,
    yandex_compute_instance.kibana.boot_disk[0].disk_id
  )
}