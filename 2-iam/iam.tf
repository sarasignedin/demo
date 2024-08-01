resource "aws_iam_group" "dev_ecommerce" {
  name = "dev_ecommerce"
}

resource "aws_iam_group_membership" "new_dev" {
  name = "new_dev"

  users = [
    "dev-user-1"
  ]

  group = aws_iam_group.dev_ecommerce.name
}

resource "aws_iam_group_policy" "dev_ecommerce" {
  name  = "dev_ecommerce"
  group = aws_iam_group.dev_ecommerce.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "*"
        ]
        Condition = {
          StringEquals = {
            "aws:ResourceTag/env" : "dev",
          }
        }
        Condition = {
          StringEquals = {
            "aws:ResourceTag/team" : "ecommerce"
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "*"
        ]
        Condition = {
          StringEquals = {
            "aws:ResourceTag/env" : "stage"
          }
        }
        Condition= {
          StringEquals = {
            "aws:ResourceTag/team" : "ecommerce"
          }
        }
        Condition = {
          DateGreaterThan = {
            "aws:CurrentTime" : "${var.stage_access_after}"
          }
        }
      }
    ]
  })
}
