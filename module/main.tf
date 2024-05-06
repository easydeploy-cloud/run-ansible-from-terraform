data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ansible" {
  ami                         = data.aws_ami.ubuntu.id #"ami-097a2df4ac947655f" #us-east-2
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.allow_tls.name]
  key_name                    = trimsuffix(var.private_key, ".pem")
  tags = {
    Name = "Apache-server"
  }
}

########################## NULL RESOURCE FOR ANSIBLE############################################3
resource "null_resource" "connect_ansible_hosts" {
  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file("${var.private_key_path}/${var.private_key}")
    host        = aws_instance.ansible.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "echo 'SSH is Getting Ready for ansible'"
    ]
  }
  #Execute the ansible command form local system
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.ansible.public_ip}, --private-key ${var.private_key_path}/${var.private_key} instance.yml"
  }
}
#################################################################################################

resource "aws_security_group" "allow_tls" {
  name        = "Apache-server"
  description = "Allow TLS inbound traffic"
  ingress {
    description = "allow access to web"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow access SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Apache-server"
  }
}

output "apache_ip" {
  value = aws_instance.ansible.public_ip
}
