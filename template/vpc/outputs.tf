output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.vpc_root.id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.public_subnet.id
}

output "public_subnet_availability_zone" {
  description = "Public Subnet Availability Zone"
  value       = aws_subnet.public_subnet.availability_zone
}

output "private_subnet_id" {
  description = "Private Subnet ID"
  value       = aws_subnet.private_subnet.id
}

output "private_subnet_availability_zone" {
  description = "Private Subnet Availability Zone"
  value       = aws_subnet.private_subnet.availability_zone
}

output "dummy_subnet_id" {
  description = "Dummy Subnet ID"
  value       = aws_subnet.dummy_subnet.id
}

output "dummy_subnet_availability_zone" {
  description = "Dummy Subnet Availability Zone"
  value       = aws_subnet.dummy_subnet.availability_zone
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw_public.id
}

output "public_security_group_id" {
  description = "Public Security Group ID"
  value       = aws_security_group.public_sg.id
}

output "private_security_group_id" {
  description = "Private Security Group ID"
  value       = aws_security_group.private_sg.id
}

output "load_balancer_security_group_id" {
  description = "Load Balancer Security Group ID"
  value       = aws_security_group.loadbalancer_sg.id
}
