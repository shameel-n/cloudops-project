output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "cluster_iam_role_name" {
  description = "IAM role name associated with EKS cluster"
  value       = module.eks.cluster_iam_role_name
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_name" {
  description = "The name/id of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = module.eks.cluster_oidc_issuer_url
}

output "node_groups" {
  description = "Map of attribute maps for all EKS managed node groups created"
  value       = module.eks.eks_managed_node_groups
}

output "vpc_id" {
  description = "ID of the VPC where the cluster is deployed"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.db_endpoint
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = module.rds.db_port
}

output "rds_database_name" {
  description = "RDS database name"
  value       = module.rds.db_name
}

output "ecr_repositories" {
  description = "Map of ECR repository URLs"
  value       = module.ecr.repository_urls
}

output "codebuild_role_arn" {
  description = "CodeBuild service role ARN"
  value       = module.codebuild_role.arn
}

output "kubectl_config_command" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

# Route53 Failover Outputs (Phase 4)
output "route53_hosted_zone_id" {
  description = "Route53 hosted zone ID"
  value       = module.route53_failover.hosted_zone_id
}

output "route53_name_servers" {
  description = "Route53 hosted zone name servers"
  value       = module.route53_failover.hosted_zone_name_servers
}

output "route53_health_check_id" {
  description = "Route53 health check ID"
  value       = module.route53_failover.health_check_id
}

output "application_dns_name" {
  description = "Application DNS name with failover"
  value       = module.route53_failover.dns_record_fqdn
}

output "load_balancer_endpoint" {
  description = "Load balancer endpoint for this region"
  value       = module.route53_failover.load_balancer_dns_name
}

output "health_check_alarm" {
  description = "CloudWatch alarm for health check"
  value       = module.route53_failover.cloudwatch_alarm_name
} 