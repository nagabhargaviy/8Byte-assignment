data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_key_pair" "app" {
  key_name   = "${var.app_name}-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = aws_key_pair.app.key_name

  user_data = <<-USERDATA
    #!/bin/bash
    yum update -y
    yum install -y docker
    service docker start
    usermod -a -G docker ec2-user
  USERDATA

  tags = {
    Name        = "${var.app_name}-server"
    Environment = var.environment
  }
}