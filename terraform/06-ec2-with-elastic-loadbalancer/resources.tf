resource "aws_default_vpc" "default_vpc" {

}

resource "aws_security_group" "http_server_security_group" {
  name   = "http_server_security_group"
  vpc_id = aws_default_vpc.default_vpc.id # aws_vpc.main.id if you've created it like this: data "aws_vpc" "main" { id = "vpc-1234567890abcdefg" }

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

resource "aws_security_group" "load_balancer_security_group" {
  name   = "load_balancer_security_group"
  vpc_id = aws_default_vpc.default_vpc.id # aws_vpc.main.id if you've created it like this: data "aws_vpc" "main" { id = "vpc-1234567890abcdefg" }

  tags = {
    name = "load_balancer_security_group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "load_balancer_security_group_ingress_rule_80" {
  security_group_id = aws_security_group.load_balancer_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "load_balancer_security_group_ingress_rule_22" {
  security_group_id = aws_security_group.load_balancer_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "load_balancer_security_group_egress_rule" {
  security_group_id = aws_security_group.load_balancer_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_instance" "http_servers" {
  ami                    = data.aws_ami.amazon-linux-2023.id # "ami-0683ee28af6610487"
  key_name               = "default-ec2-RSA"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.http_server_security_group.id]
  for_each               = toset(data.aws_subnets.default_subnets.ids)
  subnet_id              = each.value

  tags = {
    name = "HTTP Server ${each.key}"
  }

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

resource "aws_elb" "elb" {
  name = "elb"
  subnets = data.aws_subnets.default_subnets.ids
  security_groups = [aws_security_group.load_balancer_security_group.id]
  instances = values(aws_instance.http_servers).*.id

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
}
