variable "ui_instance_private_ip" {}
variable "db_instance_private_ip" {}
variable "vpc_root_id" {}
variable "client_name" {
  type = string
}
variable "environment" {
  type = string
}
variable "is_prod" {
  type = bool
}
variable "client_force_url" {
  type = string
}

resource "aws_route53_zone" "client_name_clients" {
  name = var.is_prod ? "${coalesce(var.client_force_url, var.client_name)}.clients.cx" : "${coalesce(var.client_force_url, var.client_name)}-${var.environment}.clients.cx"
  vpc {
    vpc_id = var.vpc_root_id
  }
}

resource "aws_route53_record" "client_name_clients_a" {
  zone_id = aws_route53_zone.client_name_clients.zone_id
  name    = var.is_prod ? "${coalesce(var.client_force_url, var.client_name)}.clients.cx" : "${coalesce(var.client_force_url, var.client_name)}-${var.environment}.clients.cx"
  type    = "A"
  ttl     = 300
  records = [var.ui_instance_private_ip]
}

resource "aws_route53_zone" "client_name_api_clients" {
  name = var.is_prod ? "${coalesce(var.client_force_url, var.client_name)}-api.clients.cx" : "${coalesce(var.client_force_url, var.client_name)}-${var.environment}-api.clients.cx"
  vpc {
    vpc_id = var.vpc_root_id
  }
}

resource "aws_route53_record" "client_name_api_clients_a" {
  zone_id = aws_route53_zone.client_name_api_clients.zone_id
  name    = var.is_prod ? "${coalesce(var.client_force_url, var.client_name)}-api.clients.cx" : "${coalesce(var.client_force_url, var.client_name)}-${var.environment}-api.clients.cx"
  type    = "A"
  ttl     = 300
  records = [var.ui_instance_private_ip]
}

resource "aws_route53_zone" "client_name_db_clients" {
  name = var.is_prod ? "${coalesce(var.client_force_url, var.client_name)}-db.clients.cx" : "${coalesce(var.client_force_url, var.client_name)}-${var.environment}-db.clients.cx"
  vpc {
    vpc_id = var.vpc_root_id
  }
}

resource "aws_route53_record" "client_name_db_clients_a" {
  zone_id = aws_route53_zone.client_name_db_clients.zone_id
  name    = var.is_prod ? "${coalesce(var.client_force_url, var.client_name)}-db.clients.cx" : "${coalesce(var.client_force_url, var.client_name)}-${var.environment}-db.clients.cx"
  type    = "A"
  ttl     = 300
  records = [var.db_instance_private_ip]
}