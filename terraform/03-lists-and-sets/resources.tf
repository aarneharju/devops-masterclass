resource "aws_iam_user" "aws_iam_users" {
  # count = length(var.names)
  # name  = var.names[count.index]  # Note: adding new users to the beginning of the list will recreate existing users
  for_each = toset(var.names) # Using set to avoid recreating existing users when adding new users 
  name     = each.value
}
