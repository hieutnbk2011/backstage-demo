locals {
  backstage_cpu                = 2048
  backstage_desired_count      = 1
  backstage_memory             = 4096
  backstage_memory_reservation = 4000
  backstage_port               = 7007
  backstage_task_cpu           = 2048
  backstage_task_memory        = 4096
  backstage_healthcheck_path   = "/"
}
