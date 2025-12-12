# --------------------------
# S3 Bucket for Website (existing)
# --------------------------
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name  # Must match your existing bucket

  force_destroy = true

  lifecycle {
    prevent_destroy = false
  }
}

# Make bucket public via public access block
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Configure S3 Website
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }
}

# Upload index.html to S3
resource "aws_s3_object" "html" {
  bucket       = aws_s3_bucket.website_bucket.bucket
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}

# Make bucket publicly readable via policy
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}
