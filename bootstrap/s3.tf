resource "aws_s3_bucket" "kops_state_store" {
  bucket = "${var.kops_state_store_s3_bucket_name}"
  acl = "private"

  versioning {
    enabled = true
  }
}
