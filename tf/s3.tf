resource "random_id" "random" {
  byte_length = 8
}

resource "aws_iam_user" "new_dev" {
  name          = "dev-user-1"
  force_destroy = true
}

# dev-ecommerce
resource "aws_s3_bucket" "dev_ecommerce" {
  bucket = "dev-ecommerce-${random_id.random.dec}"

  tags = {
    env  = "dev"
    team = "ecommerce"
  }
}

resource "aws_s3_bucket_policy" "dev_ecommerce" {
  bucket = aws_s3_bucket.dev_ecommerce.id
  policy = data.aws_iam_policy_document.dev_ecommerce.json
}

data "aws_iam_policy_document" "dev_ecommerce" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/dev-user-1"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
    ]

    resources = [
      "${aws_s3_bucket.dev_ecommerce.arn}",
      "${aws_s3_bucket.dev_ecommerce.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_public_access_block" "dev_ecommerce" {
  bucket = aws_s3_bucket.dev_ecommerce.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# stage-ecommerce
resource "aws_s3_bucket" "stage_ecommerce" {
  bucket = "stage-ecommerce-${random_id.random.dec}"

  tags = {
    env  = "stage"
    team = "ecommerce"
  }
}

resource "aws_s3_bucket_public_access_block" "stage_ecommerce" {
  bucket = aws_s3_bucket.stage_ecommerce.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "stage_ecommerce" {
  bucket = aws_s3_bucket.stage_ecommerce.id
  policy = data.aws_iam_policy_document.stage_ecommerce.json
}

data "aws_iam_policy_document" "stage_ecommerce" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/dev-user-1"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
    ]

    resources = [
      "${aws_s3_bucket.stage_ecommerce.arn}",
      "${aws_s3_bucket.stage_ecommerce.arn}/*",
    ]

    condition {
      test     = "DateGreaterThan"
      variable = "aws:CurrentTime"
      values   = [var.stage_access_after]
    }

    effect = "Allow"
  }
}

# prod-ecommerce
resource "aws_s3_bucket" "prod_ecommerce" {
  bucket = "prod-ecommerce-${random_id.random.dec}"

  tags = {
    env  = "prod"
    team = "ecommerce"
  }
}

resource "aws_s3_bucket_public_access_block" "prod_ecommerce" {
  bucket = aws_s3_bucket.prod_ecommerce.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# dev-infra
resource "aws_s3_bucket" "dev_infra" {
  bucket = "dev-infra-${random_id.random.dec}"

  tags = {
    env  = "dev"
    team = "infra"
  }
}

resource "aws_s3_bucket_public_access_block" "dev_infra" {
  bucket = aws_s3_bucket.dev_infra.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# stage-netinfra
resource "aws_s3_bucket" "stage_neteng" {
  bucket = "stage-neteng-${random_id.random.dec}"

  tags = {
    env  = "stage"
    team = "neteng"
  }
}

resource "aws_s3_bucket_public_access_block" "stage_neteng" {
  bucket = aws_s3_bucket.stage_neteng.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# prod-security
resource "aws_s3_bucket" "prod_security" {
  bucket = "prod-security-${random_id.random.dec}"

  tags = {
    env  = "prod"
    team = "security"
  }
}

resource "aws_s3_bucket_public_access_block" "prod_security" {
  bucket = aws_s3_bucket.prod_security.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}