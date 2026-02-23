# Policy para EC2 (ejemplo: acceso básico a SSM, expansible)
resource "aws_iam_policy" "ec2_policy" {
  name        = "EC2BasicPolicy"
  description = "Policy básica para EC2"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ssm:Describe*", "ec2:Describe*"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })

  tags = merge(local.common_tags, { Name = "EC2BasicPolicy" })
}

# Role para EC2
resource "aws_iam_role" "ec2_role" {
  name = "EC2Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(local.common_tags, { Name = "EC2Role" })
}

# Attach policy al role
resource "aws_iam_role_policy_attachment" "ec2_policy_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

# Instance Profile para asignar al EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2Profile"
  role = aws_iam_role.ec2_role.name
}