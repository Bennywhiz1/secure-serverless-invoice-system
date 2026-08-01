resource "aws_s3_bucket" "invoice_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "Invoice Upload Bucket"
    Project     = "Secure Serverless Invoice System"
    Environment = "Development"
    Owner       = "Benedict"
  }
}

resource "aws_s3_bucket_public_access_block" "invoice_bucket" {
  bucket = aws_s3_bucket.invoice_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "invoice_bucket" {
  bucket = aws_s3_bucket.invoice_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "invoice_bucket" {
  bucket = aws_s3_bucket.invoice_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}