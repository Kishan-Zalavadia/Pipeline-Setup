# ---------------------------
# LEGACY OAI (Migration Support)
# ---------------------------
# We keep this temporarily to avoid "InUse" errors during the migration to OAC.
# Once the distribution update is finished, this can be safely removed.
resource "aws_cloudfront_origin_access_identity" "frontend" {
  comment = "Legacy OAI for ${var.project_name}-${var.environment}"
}

# ---------------------------
# OAC (NEW)
# ---------------------------
resource "aws_cloudfront_origin_access_control" "frontend" {
  name                              = "${var.project_name}-${var.environment}-oac"
  description                       = "OAC for frontend S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# ---------------------------
# DISTRIBUTION
# ---------------------------
resource "aws_cloudfront_distribution" "frontend" {
  # Origin for S3 (Frontend)
  origin {
    domain_name              = var.s3_bucket_regional_domain_name
    origin_id                = "S3Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.frontend.id
  }

  # Origin for EC2 (Backend)
  origin {
    domain_name = var.backend_domain_name # This will be the EIP from EC2 module
    origin_id   = "EC2Origin"

    custom_origin_config {
      http_port              = 5050
      https_port             = 443
      origin_protocol_policy = "http-only" # EC2 is running HTTP on 5050
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  # Default Behavior (S3 Frontend)
  default_cache_behavior {
    target_origin_id       = "S3Origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    compress = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  # Cache Behavior for /auth/* (EC2 Backend)
  ordered_cache_behavior {
    path_pattern     = "/auth/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "EC2Origin"

    forwarded_values {
      query_string = true
      headers      = ["Origin", "Authorization"] # Crucial for CORS and Auth
      cookies {
        forward = "all"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache Behavior for /api/* (EC2 Backend)
  ordered_cache_behavior {
    path_pattern     = "/api/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "EC2Origin"

    forwarded_values {
      query_string = true
      headers      = ["Origin", "Authorization"]
      cookies {
        forward = "all"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # SPA routing fix
  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 300
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name        = "Frontend Distribution"
    Environment = var.environment
  }
}

# ---------------------------
# S3 BUCKET POLICY
# ---------------------------
resource "aws_s3_bucket_policy" "frontend" {
  bucket = var.s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontOAC"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${var.s3_bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.frontend.arn
          }
        }
      }
    ]
  })
}
