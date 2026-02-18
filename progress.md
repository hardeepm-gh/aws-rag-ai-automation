## Day 23: Security Hardening & Secrets Management
* **Secrets Manager:** Successfully moved away from hardcoded DB passwords.
* **Randomization:** Implemented `random_password` resource for high-entropy credentials.
* **IAM Integration:** Created an IAM Instance Profile to allow EC2 to fetch secrets without static access keys.
* **Architecture:** Linked the RDS module to the Secrets Manager value for "blind" deployments.