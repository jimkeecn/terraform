variable "ui_instance_private_ip" {}
variable "db_instance_private_ip" {}
variable "vpc_root_id" {}
variable "client_name" {
  type = string
}
variable "environment" {
  type = string
}

resource "aws_route53_zone" "client_name_clients" {
  name = "${var.environment}.clients.cx"
  vpc {
    vpc_id = var.vpc_root_id
  }
}

resource "aws_route53_record" "client_name_clients_a" {
  zone_id = aws_route53_zone.client_name_clients.zone_id
  name    = "${var.environment}.clients.cx"
  type    = "A"
  ttl     = 300
  records = [var.ui_instance_private_ip]
}

resource "aws_route53_zone" "client_name_api_clients" {
  name = "${var.environment}-api.clients.cx"
  vpc {
    vpc_id = var.vpc_root_id
  }
}

resource "aws_route53_record" "client_name_api_clients_a" {
  zone_id = aws_route53_zone.client_name_api_clients.zone_id
  name    = "${var.environment}-api.clients.cx"
  type    = "A"
  ttl     = 300
  records = [var.ui_instance_private_ip]
}

resource "aws_route53_zone" "client_name_db_clients" {
  name = "${var.environment}-db.clients.cx"
  vpc {
    vpc_id = var.vpc_root_id
  }
}

resource "aws_route53_record" "client_name_db_clients_a" {
  zone_id = aws_route53_zone.client_name_db_clients.zone_id
  name    = "${var.environment}-db.clients.cx"
  type    = "A"
  ttl     = 300
  records = [var.db_instance_private_ip]
}