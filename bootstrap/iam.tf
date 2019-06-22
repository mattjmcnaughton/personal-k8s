resource "aws_iam_group" "kops" {
  name = "kops"
}

resource "aws_iam_group_policy_attachment" "attach_ec2_full_access" {
  group      = aws_iam_group.kops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "attach_route53_full_access" {
  group      = aws_iam_group.kops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_group_policy_attachment" "attach_s3_full_access" {
  group      = aws_iam_group.kops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_group_policy_attachment" "attach_iam_full_access" {
  group      = aws_iam_group.kops.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_group_policy_attachment" "attach_vpc_full_access" {
  group      = aws_iam_group.kops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_user" "kops" {
  name = "kops"
}

resource "aws_iam_group_membership" "kops" {
  name = "kops"

  users = [
    aws_iam_user.kops.name,
  ]

  group = aws_iam_group.kops.name
}

resource "aws_iam_access_key" "kops" {
  user = aws_iam_user.kops.name
}

