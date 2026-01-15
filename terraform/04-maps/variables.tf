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

variable "names" {
  type = map(map(string)) # any, number, bool, list, map, set, object, tuple
  default = {
    "user1" : { country : "Finland", weather : "Cold", department : "Store" },
    "user2" : { country : "Sweden", weather : "Cold", department : "Accounting" },
    "user3" : { country : "Scotland", weather : "Wet", department : "Store" },
    "user4" : { country : "Belgium", weather : "Warm", department : "Maintenance" }
  }
}
