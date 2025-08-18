locals {
  project                  = "my-manage-app"
  region                   = "ap-northeast-1"
  tf_s3_bucket             = "${local.project}-terraform"
  root_state_file          = "terraform.tfstate"
  github_repository_prefix = local.project
  repository               = "asakuno/${local.github_repository_prefix}"
  base_domain              = ""
  default_tags = {
    Managed     = "terraform"
    Project     = local.project
    Environment = local.env
    repository  = local.repository
  }
}
