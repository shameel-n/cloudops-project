data "aws_lb" "application_lb" {
  count = var.load_balancer_name != "" ? 1 : 0
  name  = var.load_balancer_name
}

# Get Load Balancer by tags if name not provided
data "aws_lb" "application_lb_by_tags" {
  count = var.load_balancer_name == "" ? 1 : 0

  tags = {
    "ingress.k8s.aws/stack" = "cloudops-demo/cloudops-ingress"
  }
}

locals {
  # Use the appropriate load balancer data source
  load_balancer = var.load_balancer_name != "" ? data.aws_lb.application_lb[0] : data.aws_lb.application_lb_by_tags[0]
  lb_dns_name   = local.load_balancer.dns_name
  lb_zone_id    = local.load_balancer.zone_id
}

# Route53 Hosted Zone (only create if it doesn't exist)
resource "aws_route53_zone" "main" {
  count = var.create_hosted_zone ? 1 : 0
  name  = var.domain_name

  tags = merge(var.tags, {
    Name = "CloudOps Demo - ${var.domain_name}"
  })
}

# Use existing hosted zone if not creating new one
data "aws_route53_zone" "existing" {
  count = !var.create_hosted_zone ? 1 : 0
  name  = var.domain_name
}

locals {
  zone_id = var.create_hosted_zone ? aws_route53_zone.main[0].zone_id : data.aws_route53_zone.existing[0].zone_id
}

# Health Check for this region's endpoint
resource "aws_route53_health_check" "main" {
  fqdn                            = local.lb_dns_name
  port                            = 80
  type                            = "HTTP"
  resource_path                   = "/health"
  failure_threshold               = "3"
  request_interval                = "30"
  cloudwatch_logs_region          = var.region
  cloudwatch_alarm_region         = var.region
  measure_latency                 = true
  insufficient_data_health_status = "Failure"

  tags = merge(var.tags, {
    Name   = "CloudOps Demo - ${var.region} Health Check"
    Region = var.region
    Type   = var.failover_type
  })
}

# Route53 Record with Failover Routing
resource "aws_route53_record" "failover" {
  zone_id = local.zone_id
  name    = var.subdomain != "" ? "${var.subdomain}.${var.domain_name}" : var.domain_name
  type    = "A"

  failover_routing_policy {
    type = var.failover_type  # "PRIMARY" or "SECONDARY"
  }

  set_identifier  = "${var.region}-${var.failover_type}"
  health_check_id = aws_route53_health_check.main.id

  alias {
    name                   = local.lb_dns_name
    zone_id                = local.lb_zone_id
    evaluate_target_health = true
  }

  depends_on = [aws_route53_health_check.main]
}

# CloudWatch Alarm for Health Check
resource "aws_cloudwatch_metric_alarm" "health_check" {
  alarm_name          = "cloudops-demo-${var.region}-health-check"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1"
  alarm_description   = "This metric monitors Route53 health check for ${var.region}"
  alarm_actions       = var.sns_topic_arn != "" ? [var.sns_topic_arn] : []

  dimensions = {
    HealthCheckId = aws_route53_health_check.main.id
  }

  tags = var.tags
}

# Optional: Create SNS topic for notifications
resource "aws_sns_topic" "health_alerts" {
  count = var.create_sns_topic ? 1 : 0
  name  = "cloudops-demo-${var.region}-health-alerts"

  tags = var.tags
}

# SNS topic subscription for email alerts
resource "aws_sns_topic_subscription" "email_alerts" {
  count     = var.create_sns_topic && var.alert_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.health_alerts[0].arn
  protocol  = "email"
  endpoint  = var.alert_email
}