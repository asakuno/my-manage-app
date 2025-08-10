resource "aws_ecr_repository" "base_app" {
  name                 = "${local.project}/base/app"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}