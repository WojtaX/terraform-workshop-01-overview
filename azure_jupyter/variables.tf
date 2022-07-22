variable "locale" {
  type    = string
  default = "West Europe"
}

variable "system_kind" {
  type    = string
  default = "Linux"
}

variable "group_name" {
  type    = string
  default = "terraform_demo_rg"
}

variable "app_plan_name" {
  type    = string
  default = "terraform_demo_plan"
}

variable "app_name" {
  type    = string
  default = "terraformdemo"
}

variable "allowed_ips" {
  description = "some description"
  type = string
}