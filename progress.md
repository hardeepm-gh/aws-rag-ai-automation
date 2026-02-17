## Day 22: Multi-Tier Modular Infrastructure & RDS

**Tasks Completed:**
- [x] Created a dedicated `rds` module for managed database deployment.
- [x] Implemented **Security Group Nesting**: RDS now only accepts traffic from the Web Server's Security Group ID.
- [x] Fixed "Race Condition" errors by using explicit output-to-input handshakes between VPC and RDS modules.
- [x] Resolved plural/singular attribute mismatches in subnet list exports.
- [x] Verified full deployment of VPC, EC2, and RDS using a single `terraform apply`.

**Key Learnings:**
- **Dependency Mapping:** Learned how Terraform uses output references (e.g., `module.vpc.db_subnet_group_name`) to determine the order of resource creation.
- **Security Best Practices:** Moving from IP-based firewall rules to Resource-based (Security Group) rules.
- **RDS Requirements:** Understanding that RDS Subnet Groups require a list of IDs across at least two Availability Zones.

**Status:** Infrastructure destroyed; GitHub synced. Ready for Day 23: Secrets Management.
