output "aws_security_group_server_details" {
  value = aws_security_group.http_server_security_group
}

output "aws_http_server_details" {
  value = aws_instance.http_server
}


output "aws_public_dns" {
  value = aws_instance.http_server.public_dns
}
