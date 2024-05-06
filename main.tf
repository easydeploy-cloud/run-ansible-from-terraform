module "apache_server" {
  source      = "./module"
  ssh_user    = var.ssh_user
  private_key = var.private_key
  private_key_path = var.private_key_path
}

output "apache_server" {
  value = module.apache_server.apache_ip
}