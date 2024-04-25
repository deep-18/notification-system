terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "example" {
  key_name   = "azureAgent"
  public_key = ${{ secrets.AZUREAGENT }}
}

resource "aws_instance" "example" {
  ami           = "ami-04e5276ebb8451442"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.example.key_name

  tags = {
    Name = "example-instance"
  }
}

resource "aws_security_group" "docker" {
  name        = "docker_security_group"
  description = "Allow inbound traffic on port 80"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "example" {
  instance = aws_instance.example.id
}

resource "null_resource" "docker_deploy" {
  depends_on = [aws_instance.example]

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo service docker start",
      "sudo docker run -d -p 80:80 notification-app-image" 
    ]

    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = aws_key_pair.example.azureAgent 
      host     = aws_instance.example.public_ip
    }
  }
}

output "public_ip" {
  value = aws_instance.example.public_ip
}