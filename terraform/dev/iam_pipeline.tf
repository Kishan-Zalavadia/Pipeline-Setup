# ---------------------------
# PIPELINE PERMISSIONS (SSM & CloudFront)
# ---------------------------

# Fetch the existing GitHub Actions IAM Role
data "aws_iam_role" "pipeline_role" {
  name = "demo-project-pipeline-execution-role"
}

# Add SSM permissions to the role
resource "aws_iam_role_policy" "pipeline_ssm" {
  name = "pipeline-ssm-policy"
  role = data.aws_iam_role.pipeline_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:SendCommand",
          "ssm:GetCommandInvocation",
          "ssm:ListCommandInvocations"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudfront:CreateInvalidation"
        ]
        Resource = "*"
      }
    ]
  })
}
