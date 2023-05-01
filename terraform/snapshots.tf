#resource "yandex_compute_snapshot_schedule" "default" {
#  name           = "cw-snapshots"
#
#  schedule_policy {
#    expression = "0 0 * * *"
#  }
#  retention_period = 7
#
#  snapshot_spec {
#      description = "coursework-snapshots"
#      labels = {
#        snapshot-label = "netology"
#      }
#  }
#
#  labels = {
#    my-label = "netology-schedule"
#  }
#
#  disk_ids = concat(
#    [yandex_compute_instance_group.web-netology.instances.*.boot_disk[0].disk_id],
#    yandex_compute_instance.prometheus.boot_disk[0].disk_id,
#    yandex_compute_instance.bastion.boot_disk[0].disk_id,
#    yandex_compute_instance.elastic.boot_disk[0].disk_id,
#    yandex_compute_instance.grafana.boot_disk[0].disk_id,
#    yandex_compute_instance.kibana.boot_disk[0].disk_id
#  )
#}