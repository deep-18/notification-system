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



resource "aws_instance" "example" {
  ami           = "ami-04e5276ebb8451442"
  instance_type = "t2.micro"
  key_name      = "azureAgent"

  tags = {
    Name = "example-instance"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install docker -y
    sudo service docker start
    sudo docker login -u deepraval -p Deep12345
    sudo docker pull deepraval/notification-system:95
    sudo docker run -d --name notification-system -p 80:8000 deepraval/notification-system:95
  EOF
}


output "public_ip" {
  value = aws_instance.example.public_ip
}