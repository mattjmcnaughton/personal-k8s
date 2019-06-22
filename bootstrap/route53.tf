data "aws_route53_zone" "main" {
  name = var.existing_base_route53_zone_name
}

resource "aws_route53_zone" "k8s" {
  name = var.k8s_route53_zone_name
}

resource "aws_route53_record" "k8s-ns" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.k8s_route53_zone_name
  type    = "NS"
  ttl     = "30"

  records = [
    aws_route53_zone.k8s.name_servers[0],
    aws_route53_zone.k8s.name_servers[1],
    aws_route53_zone.k8s.name_servers[2],
    aws_route53_zone.k8s.name_servers[3],
  ]
}

