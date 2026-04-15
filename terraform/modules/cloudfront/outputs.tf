output "distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.frontend.id
}

output "domain_name" {
  description = "CloudFront domain name"
  value       = aws_cloudfront_distribution.frontend.domain_name
}

output "url" {
  description = "CloudFront URL"
  value       = "https://${aws_cloudfront_distribution.frontend.domain_name}"
}

output "oac_id" {
  description = "CloudFront Origin Access Control ID"
  value       = aws_cloudfront_origin_access_control.frontend.id
}
