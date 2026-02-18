resource "aws_iam_role" "ec2_secrets_role" {
  name = "${var.env}-ec2-secrets-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "password_policy" {
  name = "${var.env}-password-read-policy"
  role = aws_iam_role.ec2_secrets_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = "secretsmanager:GetSecretValue"
      Effect   = "Allow"
      Resource = aws_secretsmanager_secret.db_password.arn
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.env}-ec2-secrets-profile"
  role = aws_iam_role.ec2_secrets_role.name
}