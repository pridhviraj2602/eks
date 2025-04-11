packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

source "amazon-ebs" "base" {
  region        = var.aws_region
  instance_type = "t3.medium"
  ami_name      = "universal-ami-{{timestamp}}"
  ssh_username  = "ec2-user"

  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*-x86_64-gp2"
      virtualization-type = "hvm"
    }
    owners      = ["amazon"]
    most_recent = true
  }
}

build {
  name    = "universal-ami"
  sources = ["source.amazon-ebs.base"]

  provisioner "shell" {
    script = "scripts/install-common.sh"
  }
}
