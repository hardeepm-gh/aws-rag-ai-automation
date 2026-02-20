variable "env" {
  type = string
}

variable "ami_id" {
  type        = string
  description = "The AMI to use for the runner"
  default     = "ami-0c101f26f147fa7fd" # Amazon Linux 2023 in us-east-1
}