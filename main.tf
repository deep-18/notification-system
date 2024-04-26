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
  
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAmJbQ3fNIOaOSLC4GpJe/5aRmTZHO3rgXnBgjiTefc94HQ9Zc
QJQbiu4WIg130uQDTjp5egrg99Mek20upfa8libNzEc9sSwUkbggsS2aTVRZBlQq
8MJFJIdJS1xXtR88jHT1X60mHN/ZlFHP9l0EiScNm4N41C0CQ7Tdza0J2ALQrUOa
MLtxApWvae2NudeIkF9z5kNfn0S5eIk+bDc5Uuk33011MsCbQiQcfTTT/bNg7Wn2
m7O5Hdc+nOio5QEeW4wBAcBiio2jQQr6DzDxP3bzCVRxkpoNhCbkoGaeC6MWsuwk
FwHDjfBU/NYrJuVWMqc3cBXVUeco5ii73oH5OwIDAQABAoIBAHLwN8jYNrFkKvko
ekyFGkGLApyvllph5TbpX+s+gNewiVxqHfdvGQgfq4BfEMFEi9DjbxmlFCzZVJDM
j3ToVMnt1NtpVmkcwSm6vrV3mmFhheWkhOvyCk8nsOgZWN/P9bX/a810Cd96JtT4
g2QaUQ5W4oMgF2YLuUby+JizHVUeLbYJ00vBMbG0rchEtICj7uUYPVurRurffOFH
UKWFKWaG7B7zPbS43maIFeM7+bzecTe/H20jJeToKcfkGN7OCqeYOuHVYXqV022z
lWTrNtMA0UCJ7Wvu5wjjXYSrzzKHcSVYVCEQOaxqEyDcMzUd9XR5aT+o7frHz+sF
8/RC/UECgYEA36P1wjgQhW0zJI1u8+uF6UiLMGJKOOVHOH98K2waFmK8ScDkFAIn
6H+qXp8pRZAM3PYPf65MSoTwqMLQmxl7OseMWS/xYYfS2qTvfj11WIq0pSjyEvn9
SnGotCyaavcqGH0b+uChA8FwxDCVzjY2934xD+3kn6gCt+CZ5JrYBysCgYEArqr8
6w6fIXV4SKUJGRQAtMEw0RZNNZaPHv/lL48rR0gVL7ghkFwSJJHCD17G7EvmjyKn
FUyJ9rvCUq+M981/zb97V/1eGm5w/YHHeqexpCUNnuw+PulyO9l9MQXHuD+YE/8l
ynjI7V4wLzfEF1x6AE/CkrP0LNbIBRoQKH4szjECgYBvish1kR70XW2nqn8PW4YT
v2HkxPE+BWULUdJtmeI9DgvZQULAk/6xoJMp1HpyPpGb14INbbKRbFLX6SrAYOos
fACNLzNWMLdC5AarUR3pBm1o/s4WFud1LNE25BQ0i4hMZIIDE+xbAi0rPQxKqJGr
yR3RUxa3ZsXMTlKTSYO7twKBgBX5cwpLc5+s/K3+/U8HYjNbXr3fVWVZhLX8saOz
GlnEas3vF2HnA21QXR676MDPp7j4PhcC4xSEeKUYat6+HscOwQDH4m/m1xY9npAC
yumAs977j7Uwf2uiKArj1EWM0qApaGK5oWWjhOJb3LKnsr2ZSzxToXOGrfFeXwwJ
G6/xAoGAMmwYkvl/pYLt9spaCFBCS4YCENhUSVggWEtkoboLpfoWxDJMpziuu8lt
ORca9ZP8LJwG4UViKZ7XwiJvwB52MaO9fb6cfDHUO/aOyygTTXLE5l0CZsZzidgc
XR2EuTlShrEdA0ke4PFYy65FtvBs2xvMSlAl8AXgtHFqEc0T2gY=
-----END RSA PRIVATE KEY-----"
    host        = self.public_ip
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

output "public_ip" {
  value = aws_instance.example.public_ip
}