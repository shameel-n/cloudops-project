output "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  value       = local.zone_id
}

output "hosted_zone_name_servers" {
  description = "Route53 hosted zone name servers (only if created)"
  value       = var.create_hosted_zone ? aws_route53_zone.main[0].name_servers : []
}

output "health_check_id" {
  description = "Route53 health check ID"
  value       = aws_route53_health_check.main.id
}

output "health_check_fqdn" {
  description = "FQDN being monitored by health check"
  value       = aws_route53_health_check.main.fqdn
}

output "dns_record_name" {
  description = "DNS record name"
  value       = aws_route53_record.failover.name
}

output "dns_record_fqdn" {
  description = "Fully qualified domain name"
  value       = aws_route53_record.failover.fqdn
}

output "load_balancer_dns_name" {
  description = "Load balancer DNS name"
  value       = local.lb_dns_name
}

output "cloudwatch_alarm_name" {
  description = "CloudWatch alarm name for health check"
  value       = aws_cloudwatch_metric_alarm.health_check.alarm_name
}

output "sns_topic_arn" {
  description = "SNS topic ARN for alerts (if created)"
  value       = var.create_sns_topic ? aws_sns_topic.health_alerts[0].arn : var.sns_topic_arn
} 