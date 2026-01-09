resource "aws_iam_user" "aws_iam_users" {
  count = 3
  name  = "${var.iam_user_name_prefix}-${count.index + 1}"
}
