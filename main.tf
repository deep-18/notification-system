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


resource "null_resource" "docker_deploy" {
  depends_on = [aws_instance.example]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("./azureAgent.pem")}"
    host     = aws_instance.example.public_ip
  }
  provisioner "remote-exec" {
    inline = [ 
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo service docker start",
      "sudo docker login -u deepraval -p Deep12345",  
      "sudo docker pull notification-system",  
      "sudo docker run -d -p 80:80 notification-system"
    ]
  }
}

output "public_ip" {
  value = aws_instance.example.public_ip
}