resource "aws_s3_bucket_policy" "allow_access_from_hello_world_cdn_distribution" {
  bucket = aws_s3_bucket.hello_world_bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_hello_world_cdn_distribution.json
}

data "aws_iam_policy_document" "allow_access_from_hello_world_cdn_distribution" {
  statement {
    actions = [
      "s3:GetObject*"
    ]

    effect = "Allow"

    resources = [
      "${aws_s3_bucket.hello_world_bucket.arn}/*"
    ]

    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type = "Service"
    }

    condition {
      test     = "StringEquals"
      values = [aws_cloudfront_distribution.hello_world_cdn_distribution.arn]
      variable = "AWS:SourceArn"
    }
  }
}

resource "aws_cloudfront_origin_access_control" "hello_world_cdn_origin_access_control" {
  name                              = "${aws_s3_bucket.hello_world_bucket.id}_cdn_access_control"
  description                       = "Hello World Static Site CDN Origin Access Control Configuration"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "hello_world_cdn_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  default_root_object = var.hello_world_site_content

  comment = "Use CloudFront CDN to allowing secure public access to HelloWorld static site."

  tags = {
    Name        = "Hello World Static Site CDN Distribution"
    Environment = "At-Bay Recruitment Assignment"
  }

  origin {
    domain_name              = aws_s3_bucket.hello_world_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.hello_world_cdn_origin_access_control.id
    origin_id                = aws_s3_bucket.hello_world_bucket.id
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    target_origin_id       = var.hello_world_s3_bucket_name
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 10
    max_ttl                = 60

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      locations = ["IL"]
      restriction_type = "whitelist"
    }
  }
}
