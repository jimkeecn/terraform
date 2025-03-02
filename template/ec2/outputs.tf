# Outputs for future use in Route 53 or Load Balancer

//Public Production UI Instance
output "ui_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ui_instance.id
}

output "ui_public_ip" {
  description = "Public IP of the instance"
  value       = aws_eip.ui_instance_eip.public_ip
}

output "ui_private_ip" {
  description = "Private IP of the instance"
  value       = aws_instance.ui_instance.private_ip
}

output "ui_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.ui_instance.arn
}

//Private Private DB Instance
output "db_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.db_instance.id
}

output "db_public_ip" {
  description = "Public IP of the instance"
  value       = aws_eip.db_instance_eip.public_ip
}

output "db_private_ip" {
  description = "Private IP of the instance"
  value       = aws_instance.db_instance.private_ip
}

output "db_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.db_instance.arn
}