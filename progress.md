📅 Day 31: Infrastructure Hardening & Phase 1 Completion
🎯 Objectives
Finalize the High-Availability (HA) 3-tier architecture.

Secure the environment using KMS and Secrets Manager.

Resolve environment drift and "502 Bad Gateway" connectivity issues.

🛠️ Key Achievements
Identity Synchronization: Successfully resolved EntityAlreadyExists errors by importing the aws_iam_instance_profile into the Terraform state.

Secrets Management: Implemented AWS Secrets Manager to store database credentials, moving away from plaintext variables.

Encryption at Rest: Provisioned a KMS Customer Managed Key (CMK) with automatic rotation enabled to encrypt sensitive data.

Instance Recovery: Leveraged aws autoscaling start-instance-refresh to recycle the fleet, ensuring all instances assumed the correct IAM roles and passed ALB health checks.

Verified Connectivity: Confirmed public-to-private traffic flow via the ALB URL: Success from ip-10-0-1-249.ec2.internal.

🧩 Technical Challenges Overcome
The 502 Bad Gateway: Diagnosed that the ALB was failing to communicate with instances after an IAM profile import. Solved via an ASG Instance Refresh.

IAM Permissions: Correctly identified that the EC2 Instance Role follows the Principle of Least Privilege and should not have permissions to manage its own Auto Scaling Group.

Cross-Module Dependencies: Linked the Security module's KMS outputs to the Secrets Manager resource for a hardened security posture.

💡 SAA-C03 Insights Gained
State Management: Learned that terraform import is the primary tool for reconciling "Reality vs. Code" when resources already exist in AWS.

Health Checks: Understood that a 502 error is specifically an ALB-to-Instance communication failure, often solved by checking Security Groups or Instance Health.

Secrets vs. Parameter Store: Implemented Secrets Manager specifically for the benefit of future Secret Rotation (a key exam topic).

📍 Project Status
Phase 1 (Infrastructure Foundation): 100% COMPLETE ✅

Phase 2 (DevSecOps & Containers): Kicking off Monday, March 1st.