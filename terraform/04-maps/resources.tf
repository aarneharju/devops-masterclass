resource "aws_iam_user" "aws_iam_users" {
  for_each = var.names
  name     = each.key
  tags = {
    country : each.value.country,
    weather : each.value.weather,
    department : each.value.department
  }
}
