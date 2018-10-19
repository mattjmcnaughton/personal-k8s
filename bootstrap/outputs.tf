output "kops_iam_access_key_id" {
  value = "${aws_iam_access_key.kops.id}"
}

output "kops_iam_access_key_secret" {
  value = "${aws_iam_access_key.kops.secret}"
}

output "k8s_subdomain" {
  value = "${aws_route53_zone.k8s.name}"
}

output "kops_state_store" {
  value = "${aws_s3_bucket.kops_state_store.id}"
}
