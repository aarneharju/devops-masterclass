variable "infisical_client_id" {
  type      = string
  sensitive = true
}

variable "infisical_client_secret" {
  type      = string
  sensitive = true
}

variable "infisical_project_id" {
  type      = string
  sensitive = true
}

module "user_module" {
  source                   = "../../terraform-modules/users"
  environment              = "dev"
  infisical_client_id      = var.infisical_client_id
  infisical_client_secret  = var.infisical_client_secret
  infisical_project_id     = var.infisical_project_id
}