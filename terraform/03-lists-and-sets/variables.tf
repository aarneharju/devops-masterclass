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

# variable "names" {
#   type    = list(string) # any, number, bool, list, map, set, object, tuple
#   default = ["This-user-was-added-to-the-beginning-of-the-list", "terraform-created-user-1", "terraform-created-user-2", "terraform-created-user-3"]
# }

variable "names" {
  type    = set(string) # any, number, bool, list, map, set, object, tuple
  default = ["This-user-was-added-to-the-beginning-of-the-set", "terraform-created-user-1", "terraform-created-user-2", "terraform-created-user-3"]
}
