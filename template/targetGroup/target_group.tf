variable "vpc_root_id" {}
variable "ui_instance_id" {}
variable "db_instance_id" {}
variable "environment" {
  
}

resource "aws_lb_target_group" "http_tg" {
  name     = "${var.environment}HttpTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_root_id
  target_type = "instance"
}

resource "aws_lb_target_group" "https_tg" {
  name     = "${var.environment}HttpsTG"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = var.vpc_root_id
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "http_tg_attachment" {
  target_group_arn = aws_lb_target_group.http_tg.arn
  target_id        = var.ui_instance_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "https_tg_attachment" {
  target_group_arn = aws_lb_target_group.https_tg.arn
  target_id        = var.db_instance_id
  port             = 443
}