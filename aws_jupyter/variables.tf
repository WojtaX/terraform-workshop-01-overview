variable "network_address" {
  description = "Private Ip"
  type        = string
  default     = "172.16.10.0/24"
}
variable "region" {
  description = "aws region"
  type        = string
  default     = "us-east-1a"
}

variable "main_env_tag" {
  description = "main tag for environment"
  type        = string
  default     = "terraform_demo"
}

variable "ami" {
  description = "ami"
  type        = string
  default     = "ami-04ad2567c9e3d7893"
}

variable "allowed_ips" {
  type = list(string)
}