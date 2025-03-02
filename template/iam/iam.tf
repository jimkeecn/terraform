variable "environment" {
  type = string
}

resource "aws_iam_role" "ui_ec2_role" {
  name = "${var.environment}DBEC2AccessRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "s3_full_access" {
  name       = "ui_s3_full_access"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  roles      = [aws_iam_role.ui_ec2_role.name]
}

resource "aws_iam_policy_attachment" "iam_read_only" {
  name       = "ui_iam_read_only"
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
  roles      = [aws_iam_role.ui_ec2_role.name]
}

resource "aws_iam_policy_attachment" "ssm_full_access" {
  name       = "ui_ssm_full_access"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  roles      = [aws_iam_role.ui_ec2_role.name]
}

resource "aws_iam_policy_attachment" "kms_power_user" {
  name       = "ui_kms_power_user"
  policy_arn = "arn:aws:iam::aws:policy/AWSKeyManagementServicePowerUser"
  roles      = [aws_iam_role.ui_ec2_role.name]
}

resource "aws_iam_instance_profile" "ui_ec2_instance_profile" {
  name = "${var.environment}DBEC2InstanceProfile"
  role = aws_iam_role.ui_ec2_role.name
}

