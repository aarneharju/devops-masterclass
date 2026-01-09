variable "infisical_client_id" {
  type        = string
  sensitive   = true
  description = "Infisical Machine Identity Client ID"
}

variable "infisical_client_secret" {
  type        = string
  sensitive   = true
  description = "Infisical Machine Identity Client Secret"
}

variable "infisical_project_id" {
  type        = string
  sensitive   = true
  description = "Infisical Project ID"
}

variable "iam_user_name_prefix" {
  type    = string # any, number, bool, list, map, set, object, tuple
  default = "terraform-created-user"
}
