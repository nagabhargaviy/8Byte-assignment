output "alb_dns_name" {
  description = "Access the app at this URL"
  value       = aws_lb.main.dns_name
}

output "ec2_public_ip" {
  description = "SSH into EC2 at this IP"
  value       = aws_instance.app.public_ip
}

output "rds_endpoint" {
  description = "Database connection endpoint"
  value       = aws_db_instance.postgres.endpoint
  sensitive   = true
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}