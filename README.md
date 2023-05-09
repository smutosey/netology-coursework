# Курсовой проект по профессии «DevOps-инженер с нуля» -`Недорезов Александр`

[Задача (ссылка на ТЗ)](https://github.com/netology-code/sys-diplom/blob/main/README.md) — разработать отказоустойчивую инфраструктуру для сайта, включающую мониторинг, сбор логов и резервное копирование основных данных. Инфраструктура должна размещаться в Yandex Cloud.

### Структура репозитория:
1. [/terraform/](https://github.com/smutosey/netology-coursework/tree/master/terraform) - скрипты Terraform для создания инфраструктуры в Yandex Cloud
   1. [meta/](https://github.com/smutosey/netology-coursework/tree/master/terraform/meta) - файлы cloud-config с первичной настройкой ВМ
   2. [templates/](https://github.com/smutosey/netology-coursework/tree/master/terraform/templates) - шаблоны .tftpl, в нашем случае шаблоном формируем inventory для ansible
   3. [terraform.tfvars.example](https://github.com/smutosey/netology-coursework/blob/master/terraform/terraform.tfvars.example) - пример файла с переменными, необходимыми для запуска terraform apply
2. [/ansible/](https://github.com/smutosey/netology-coursework/tree/master/ansible) - yaml-конфигурации виртуальных машин в облаке
   1. [roles/](https://github.com/smutosey/netology-coursework/tree/master/ansible/roles) - роли Ansible
   2. [playbook.yml](https://github.com/smutosey/netology-coursework/blob/master/ansible/playbook.yaml) - основной плейбук для конфигурации инфраструктуры
   3. [inventory.yaml.example](https://github.com/smutosey/netology-coursework/blob/master/ansible/inventory.yaml.example) - пример генерируемого с помощью terraform-шаблона Inventory
   4. [domain-accept.yaml](https://github.com/smutosey/netology-coursework/blob/master/ansible/domain-accept.yaml) - отдельный плейбук для подтверждения права владения доменом


