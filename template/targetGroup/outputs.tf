output "http_tg_id" {
    description = "ID of the Target Group HTTP (Production)"
    value       = aws_lb_target_group.http_tg.id
}

output "https_tg_id" {
    description = "ID of the Target Group HTTPS (Production)"
    value       = aws_lb_target_group.https_tg.id
}