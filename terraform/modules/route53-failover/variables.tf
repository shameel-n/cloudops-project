variable "domain_name" {
  description = "The domain name for the hosted zone"
  type        = string
}

variable "subdomain" {
  description = "Subdomain for the application (optional)"
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS region where this endpoint is deployed"
  type        = string
}

variable "failover_type" {
  description = "Failover routing type: PRIMARY or SECONDARY"
  type        = string
  validation {
    condition     = contains(["PRIMARY", "SECONDARY"], var.failover_type)
    error_message = "Failover type must be either PRIMARY or SECONDARY."
  }
}

variable "load_balancer_name" {
  description = "Name of the Application Load Balancer (optional if using tags)"
  type        = string
  default     = ""
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

variable "sns_topic_arn" {
  description = "Existing SNS topic ARN for alerts (optional)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
} 