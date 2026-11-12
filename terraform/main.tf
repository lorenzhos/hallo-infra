terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_lightsail_key_pair" "meiner" {
  name       = "terraform-key"
  public_key = file("${path.module}/lightsail.pub")
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_lightsail_instance" "proxy" {
  name              = "proxy"
  availability_zone = "eu-central-1a"
  blueprint_id      = "ubuntu_24_04"
  bundle_id         = "nano_3_0"
  key_pair_name     = aws_lightsail_key_pair.meiner.name

}

resource "aws_lightsail_instance" "backend" {
  name              = "backend"
  availability_zone = "eu-central-1a"
  blueprint_id      = "ubuntu_24_04"
  bundle_id         = "nano_ipv6_3_0"
  key_pair_name     = aws_lightsail_key_pair.meiner.name
  ip_address_type   = "ipv6"
}

resource "aws_lightsail_instance" "db" {
  name              = "db"
  availability_zone = "eu-central-1a"
  blueprint_id      = "ubuntu_24_04"
  bundle_id         = "micro_ipv6_3_0"
  key_pair_name     = aws_lightsail_key_pair.meiner.name
  ip_address_type   = "ipv6"
}

resource "aws_lightsail_instance_public_ports" "proxy" {
  instance_name = aws_lightsail_instance.proxy.name

  port_info {
    protocol   = "tcp"
    from_port  = 443
    to_port    = 443
    cidrs      = ["0.0.0.0/0"]
    ipv6_cidrs = ["::/0"]
  }

  port_info {
    protocol   = "tcp"
    from_port  = 80
    to_port    = 80
    cidrs      = ["0.0.0.0/0"]
    ipv6_cidrs = ["::/0"]
  }

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidrs     = ["0.0.0.0/0"]
  }
}

output "proxy_public_ip" {
  value = aws_lightsail_instance.proxy.public_ip_address
}

output "private_ips" {
  value = {
    "db"      = aws_lightsail_instance.db.private_ip_address
    "proxy"   = aws_lightsail_instance.proxy.private_ip_address
    "backend" = aws_lightsail_instance.backend.private_ip_address
  }
}


resource "aws_lightsail_instance_public_ports" "backend" {
  instance_name = aws_lightsail_instance.backend.name

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidrs     = ["172.26.0.0/16"]
  }
}

resource "aws_lightsail_instance_public_ports" "db" {
  instance_name = aws_lightsail_instance.db.name

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidrs     = ["172.26.0.0/16"]
  }
}
