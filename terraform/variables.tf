variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "naga-dev-eks"
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.33"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "staging"
}

##Database
variable "app_name" {
  description = "Application name"
  type        = string
  default     = "8Byte-assignment"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "appdb"
}

