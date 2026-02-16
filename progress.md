## Day 21: Modularizing the AWS Landing Zone

**Tasks Completed:**
- [x] Refactored monolithic Terraform code into `vpc` and `ec2` modules.
- [x] Resolved Multi-AZ RDS Subnet Group errors by implementing `count` and dynamic Availability Zone lookups.
- [x] Established cross-module data flow using Outputs and Variables.
- [x] Verified successful EC2 deployment with dynamic AMI discovery.

**Key Learnings:**
- Mastered the "Output Handshake": passing data from a network module to a compute module.
- Understanding the strict Multi-AZ requirements for AWS RDS (minimum 2 AZs).
- Using `terraform init` to re-index renamed or newly added local modules.

**Status:** Infrastructure destroyed to save costs; ready for Day 22 RDS deployment.
