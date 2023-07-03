variable "my_ip" {
  type    = string
  default = "178.17.15.151"
}

variable "enable_jump" {
  type    = bool
  default = true
}

variable "enable_runner" {
  type    = bool
  default = true
}

variable "enable_vpn" {
  type    = bool
  default = false
}

variable "provision_aad" {
  type    = bool
  default = false
}

variable "github_runner_token" {
  type      = string
  sensitive = true
  default   = ""
}

variable "location" {
  type    = string
  default = "westeurope"
}
