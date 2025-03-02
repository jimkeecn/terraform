variable "http_tg_id" {}
variable "https_tg_id" {}
variable "vpc_root_id" {}
variable "vpc_public_subnet_id" {}
variable "vpc_dummy_subnet_id" {}
variable "certifcate_arn" {
  type = string
}
variable "load_balancer_security_group_id" {}
variable "environment" {
  type = string
}
variable "ssl_policy" {
  type = string
}

resource "aws_lb" "public_alb" {
  name               = "${var.environment}PublicALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.load_balancer_security_group_id] # Add security group IDs here if needed
  subnets            = [var.vpc_public_subnet_id, var.vpc_dummy_subnet_id]
  enable_deletion_protection = false
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.http_tg_id
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certifcate_arn

  default_action {
    type             = "forward"
    target_group_arn = var.https_tg_id
  }
}