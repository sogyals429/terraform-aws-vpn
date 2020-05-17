resource "aws_acm_certificate" "sogyalsherpa_acm" {
  domain_name       = "sogyalsherpa.com"
  validation_method = "DNS"
  tags = merge({
    Name="sogyalsherpa-certificate"
  },local.common_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}
