packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "image" {

  region         = var.region
  source_ami     = var.ami_id
  instance_type  = var.instance_type
  ssh_username   = "ec2-user"
  ami_name       = local.image_name

  subnet_id      = "subnet-0405019b56d3a7518"   # <-- YOUR SUBNET ID
  associate_public_ip_address = true             # ✅ add this line
  ssh_timeout    = "10m"                         # optional, but recommended

  tags = {
    Name           = local.image_name
    Project        = var.project_name
    Environment    = var.project_environment
  }
}

build {

  sources = [ "source.amazon-ebs.image" ]

  provisioner "file" {
    source      = "../website"
    destination = "/tmp/"
  }

  provisioner "shell" {
    script          = "./provision.sh"
    execute_command = "sudo {{.Path}}"
  }
}
