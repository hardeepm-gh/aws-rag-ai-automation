📅 Day 30: The Compute & Scaling Breakthrough
🎯 Objectives
Deploy a High-Availability (HA) Web Tier using Terraform.

Bridge the gap between Networking (VPC) and Compute (ASG).

Implement secure instance management via AWS Systems Manager (SSM).

🛠️ Key Achievements
State Management Mastery: Resolved "EntityAlreadyExists" and "Resource already managed" errors using terraform state rm and terraform import.

Cross-Module Communication: Successfully mapped outputs from VPC, Security, and ALB modules as inputs for the EC2 module.

Bootstrap Success: Configured a user_data script that successfully installs Apache on instances in private subnets via a NAT Gateway.

Architectural Validation: Verified traffic flow through the Application Load Balancer to private EC2 instances.

🧩 Technical Challenges Overcome
IAM Instance Profile Conflict: Handled the mismatch between local Terraform state and remote AWS resources.

Modular Logic: Debugged the "Missing Required Argument" errors by standardizing variable names across the root and child modules.

ALB Target Registration: Fixed the empty target group issue by correctly linking the ASG to the ALB Target Group ARN.

💡 SAA-C03 Insights Gained
Security Group Chaining: Learned that the most secure way to allow traffic is to reference the Source Security Group ID (ALB SG) rather than an IP range.

Statefulness: Confirmed Security Groups allow return traffic automatically, simplifying private subnet communication.

SSM vs SSH: Understood why AWS recommends SSM over Bastion hosts (no port 22 exposure, easier IAM-based auditing).

📍 Current Status
VPC Layer: 100%

Security Layer: 100%

Compute/ALB Layer: 100% (Verified Live)