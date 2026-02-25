# ☁️ AWS DevOps Journey: Day 28
## Project: Secure 3-Tier Architecture (Private VPC)

### ✅ Status: SUCCESS
* **Networking:** Successfully moved EC2 instances to **Private Subnets**.
* **Connectivity:** Implemented **NAT Gateway** for outbound internet access (fixed the 504 error).
* **Database:** Connected EC2 to **RDS MySQL** using dynamic endpoints.
* **Security:** Implemented Security Group chaining (ALB -> EC2).

### 🧠 SAA-C03 Key Concept
Managed NAT Gateways live in Public Subnets but serve Private Subnets. They are essential for security-first architectures to allow private instances to download patches while remaining unreachable from the public internet.
