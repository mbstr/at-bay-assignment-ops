resource "aws_s3_object" "hello_world_site_content" {
  bucket = aws_s3_bucket.hello_world_bucket.id
  key    = var.hello_world_site_content
  source = var.hello_world_site_content_source
  etag = filemd5(var.hello_world_site_content_source)
  content_type = "text/html"
}
