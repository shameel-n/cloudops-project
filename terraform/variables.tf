variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "demo"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "cloudops-demo"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.27"
}

variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = "cloudops_demo"
}

variable "db_username" {
  description = "RDS database username"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
}

variable "node_group_instance_types" {
  description = "List of instance types for the EKS node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_group_min_size" {
  description = "Minimum size of the node group"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum size of the node group"
  type        = number
  default     = 10
}

variable "node_group_desired_size" {
  description = "Desired size of the node group"
  type        = number
  default     = 3
}

# Route53 Failover Variables (Phase 4)
variable "domain_name" {
  description = "Domain name for Route53 hosted zone"
  type        = string
  default     = "cloudops-demo.example.com"
}

variable "subdomain" {
  description = "Subdomain for the application (optional)"
  type        = string
  default     = ""
}

variable "failover_type" {
  description = "Failover routing type: PRIMARY or SECONDARY"
  type        = string
  default     = "PRIMARY"
  validation {
    condition     = contains(["PRIMARY", "SECONDARY"], var.failover_type)
    error_message = "Failover type must be either PRIMARY or SECONDARY."
  }
}

variable "create_hosted_zone" {
  description = "Whether to create a new hosted zone or use existing one"
  type        = bool
  default     = true
}

variable "create_sns_topic" {
  description = "Whether to create SNS topic for health check alerts"
  type        = bool
  default     = true
}

variable "alert_email" {
  description = "Email address for health check alerts"
  type        = string
  default     = ""
} 