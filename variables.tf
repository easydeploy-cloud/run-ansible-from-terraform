variable "region" {
  type = string
  default = "us-east-2"
}

variable "ssh_user" {
  type    = string
  default = "ubuntu"
}
variable "private_key" {
  type    = string
  default = "sk-ohio.pem"    //change the key name
}
variable "private_key_path" {
  type = string
  default = "/home/surya"  //change the path
}
variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}
