# In the source directory for the "security" module
# e.g., modules/security/variables.tf

variable "vpc_id" {
  description = "The ID of the VPC to associate with security resources"
  type        = string
}

variable "env" {
  description = "The environment name (e.g., dev, staging)"
  type        = string
}
