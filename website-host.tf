resource "aws_s3_bucket" "hello_world_bucket" {
  bucket        = var.hello_world_s3_bucket_name
  force_destroy = true

  tags = {
    Name        = "Hello World Static Site"
    Environment = "At-Bay Recruitment Assignment"
  }
}

resource "aws_s3_bucket_cors_configuration" "hello_world_bucket_cors" {
  bucket = aws_s3_bucket.hello_world_bucket.id

  cors_rule {
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = [aws_s3_bucket.hello_world_bucket.bucket_regional_domain_name]
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "hello_world_bucket_encryption" {
  bucket = aws_s3_bucket.hello_world_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "hello_world_bucket_public_blockade" {
  bucket = aws_s3_bucket.hello_world_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
