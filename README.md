1. Architecture Overview:

Internet → ALB (Load Balancer)
↓
EC2 (t2.micro) ← Docker container running FastAPI
↓
RDS PostgreSQL (db.t3.micro) — private subnet

2. Tech Stack

Component                 Tool Used
----------------------------------------
Infrastructure          Terraform on AWS
App                     FastAPI + PostgreSQL
Containers              Docker
CI/CD                   GitHub Actions
Container Registry      GitHub Container Registry (ghcr.io)
Monitoring              Prometheus + Grafana
Logging                 Grafana Loki + Promtail
Security Scanning       Trivy + pip-audit

4.Prerequisites

- Terraform >= 1.6
- AWS CLI configured
- Docker & Docker Compose
- GitHub account

5. Setup Instructions

  5a. Clone the repository
```bash
git clone https://github.com/nagabhargaviy/8Byte-assignment.git
cd 8Byte-assignment
```

  5b. Provision Infrastructure
```bash
cd terraform
terraform init
terraform plan -var="db_password=YOUR_PASSWORD"
terraform apply -var="db_password=YOUR_PASSWORD"
```

  5c. Run Locally with Docker
```bash
docker compose up -d
```

  5d. Start Monitoring Stack
```bash
cd monitoring
docker compose -f docker-compose.yml up -d
```
Access Grafana at: http://localhost:3001 (admin/admin123)

6. CI/CD Pipeline Flow
PR opened → CI runs tests + security scan
↓
Merge to main → Build Docker image → Push to ghcr.io
↓
Auto deploy to Staging
↓
Manual approval → Deploy to Production

7. Architecture Decisions

  7a. Why EC2 over ECS/EKS?
EC2 t2.micro stays within AWS free tier. ECS/EKS incurs additional costs
not suitable for a demo assignment. In production, ECS Fargate would be preferred.

  7b. Why GitHub Actions over Jenkins?
GitHub Actions requires no additional infrastructure to manage.
It integrates natively with the GitHub repository and is free for public repos.

  7c. Why Prometheus + Grafana over CloudWatch?
Open source, no additional AWS cost, and more flexible dashboarding.
CloudWatch would be preferred in a full production setup for native AWS integration.

  7d. Why single NAT Gateway?
Cost optimization — single NAT Gateway saves ~$30/month vs per-AZ setup.
In production, per-AZ NAT Gateways would be used for high availability.

8. Security Considerations

- RDS in private subnet — not publicly accessible
- App security group only accepts traffic from ALB
- RDS security group only accepts traffic from app EC2
- SSH restricted (should be limited to specific IP in production)
- Docker images scanned with Trivy on every build
- Dependencies scanned with pip-audit on every PR
- Secrets stored in GitHub Secrets — never in code

9. Cost Optimization

- EC2 t2.micro — free tier (750 hrs/month)
- RDS db.t3.micro — free tier (750 hrs/month)
- Single NAT Gateway — saves ~$30/month
- GitHub Container Registry — free for public repos
- GitHub Actions — free for public repos
- S3 for Terraform state — minimal cost (~$0.023/GB)

10. Secret Management

Secrets are managed via:
- GitHub Secrets for CI/CD pipeline variables
- AWS Secrets Manager for application runtime secrets
- No secrets hardcoded anywhere in the codebase

11. Backup Strategy

- RDS automated backups enabled — 7 day retention
- Backup window: 03:00-04:00 UTC daily
- Point-in-time recovery available within retention period
- Terraform state stored in S3 with versioning

12. Monitoring

Two Grafana dashboards:
1. Node Exporter Full (ID: 1860) — CPU, Memory, Disk, Network
2. Docker and System Metrics — Container metrics, CPU usage

Logs centralized via Loki + Promtail.