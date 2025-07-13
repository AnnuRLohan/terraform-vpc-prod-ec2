resource "aws_key_pair" "deployer" {
  key_name  = "terraform-key-day7"
  public_key = file("terraform-key-day7.pub")
}

resource "aws_security_group" "public_sg" {
    name  = "public-ec2-sg"
    description = "Allow SSH"
    vpc_id      = aws_vpc.main.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port  = 0
        to_port    = 0
        protocol   = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "public-ec2-sg"
    }
}

resource "aws_security_group" "private_sg" {
    name       = "private-ec2-sg"
    description = "Allow all egress"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        security_groups = [aws_security_group.public_sg.id]
    }

    egress {
        from_port  = 0
        to_port  = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "private-ec2-sg"
    }
}

resource "aws_instance" "public_ec2" {
    ami  = "ami-0150ccaf51ab55a51"
    instance_type  = "t2.micro"
    subnet_id   = aws_subnet.public[0].id
    key_name     = aws_key_pair.deployer.key_name
    security_groups = [aws_security_group.public_sg.id]

    user_data  = <<-EOF
                  #!/bin/bash
                  echo "Hello from PUBLIC instance" > /var/www/html/index.html
                  yum install -y httpd
                  systemctl start httpd
                  systemctl enable httpd
                  EOF
    tags = {
        Name = "public-ec2"
    }
}

resource "aws_instance" "private_ec2" {
    ami   = "ami-0150ccaf51ab55a51"
    instance_type  = "t2.micro"
    subnet_id     = aws_subnet.private[0].id
    key_name      = aws_key_pair.deployer.key_name
    security_groups = [aws_security_group.private_sg.id]

    user_data  = <<-EOF
                 #!/bin/bash
                 echo "Hello from PRIVATE instance" > /tmp/hello.txt
                 yum install -y curl
                 curl https://ifconfig.me > /tmp/my-ip.txt
                 EOF
    tags    = {
        Name    = "private-ec2"
    }
}

