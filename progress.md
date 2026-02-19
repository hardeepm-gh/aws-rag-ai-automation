## Day 24: Modular Networking & Infrastructure "Glue"
* **VPC Refactoring:** Successfully deployed a custom VPC with multiple public subnets across AZs.
* **Module Connectivity:** Implemented "Glue" logic to pass Security Group IDs and Subnet IDs between modules.
* **Security v3:** Resolved dependency violations by decoupling security rules from the EC2 module.
* **Infrastructure as Code:** Achieved a clean `terraform apply` for a full 3-tier stack (VPC, EC2, RDS).