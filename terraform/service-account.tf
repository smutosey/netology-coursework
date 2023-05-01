resource "yandex_iam_service_account" "dude" {
  name        = "dude"
  description = "service account to manage VMs"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.yc_folder_id
  role      = "editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.dude.id}",
  ]
}
