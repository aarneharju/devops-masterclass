resource "aws_default_vpc" "default_vpc" {

}

resource "aws_security_group" "http_server_security_group" {
  name   = "http_server_security_group"
  vpc_id = aws_default_vpc.default_vpc.id # aws_vpc.main.id if you've created it like this: data "aws_vpc" "main" { id = "vpc-1234567890abcdefg" }

  # Old way
  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = -1
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  tags = {
    name = "http_server_security_group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http_server_security_group_ingress_rule_80" {
  security_group_id = aws_security_group.http_server_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "http_server_security_group_ingress_rule_22" {
  security_group_id = aws_security_group.http_server_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "http_server_security_group_egress_rule" {
  security_group_id = aws_security_group.http_server_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_instance" "http_server" {
  ami                    = data.aws_ami.amazon-linux-2023.id # "ami-0683ee28af6610487"
  key_name               = "default-ec2-RSA"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.http_server_security_group.id]
  subnet_id              = data.aws_subnets.default_subnets.ids.2
  # subnet_id              = "subnet-006718fbad7fb10fb"

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_keypair)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",                                                                           // install httpd
      "sudo service httpd start",                                                                            // start server
      "echo Welcome to the Server! - I am located at ${self.public_dns} | sudo tee /var/www/html/index.html" // copy a file
    ]
  }
}
