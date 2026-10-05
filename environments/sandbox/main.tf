module "workload" {
  source = "../../modules/sandbox-workload"

  pr_number   = var.pr_number
  created_at  = var.created_at
  environment = "sandbox"
}

output "sandbox_bucket" {
  value = module.workload.bucket_name
}