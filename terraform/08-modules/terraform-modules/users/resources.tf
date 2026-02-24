resource "aws_iam_user" "terraform_created_user" {
  name = "${local.username_base}_${var.environment}"
}

locals {
  username_base = "terraform_created_user_with_locals"
}
