resource "aws_s3_bucket" "request" {
  bucket        = var.request_bucket
  force_destroy = true

  tags = {
    Environment = "Dev"
    Name        = "Request Bucket"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "request_lifecycle" {
  bucket = aws_s3_bucket.request.id
  rule {
    id     = "auto-delete"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = 7
    }
  }
}

resource "aws_s3_bucket" "response" {
  bucket        = var.response_bucket
  force_destroy = true

  tags = {
    Environment = "Dev"
    Name        = "Response Bucket"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "response_lifecycle" {
  bucket = aws_s3_bucket.response.id

  rule {
    id     = "auto-delete"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = 7
    }
  }
}
