# bootstrap

This repo contains the code for creating the AWS prerequisites for a k8s
cluster on AWS via terraform, and helper code and instructions for creating an
k8s cluster on AWS via terraform.

## Background

Currently, [kops](https://github.com/kubernetes/kops) documentation for creating
a [Kubernetes cluster via kops on
AWS](https://github.com/kubernetes/kops/blob/master/docs/aws.md) has a number of
AWS prerequisites that must be in place before we can run kops. The
documentation enumerates these prerequisites in the [Setup your
environment](https://github.com/kubernetes/kops/blob/master/docs/aws.md#setup-your-environment)
section. At the time of this commit, kops needs a `kops` IAM user with the
proper permissions, an s3 bucket in which kops can store state, and the proper
DNS configuration. Note, Kops supports a number of different DNS configuration
options. We use [Scenario
1b.](https://github.com/kubernetes/kops/blob/master/docs/aws.md#scenario-1b-a-subdomain-under-a-domain-purchasedhosted-via-aws), where we own and manage a root domain in Route53,
and want Kubernetes to use a subdomain of the root domain for its DNS records.

kops documentation provides procedural shell commands using the [aws
cli](https://aws.amazon.com/cli/). This project accomplishes the same goals as
those iterative commands, but using [terraform](https://www.terraform.io).
Terraform is a powerful tool for infrastructure as code, and offers [considerable
advantages](https://www.safaribooksonline.com/library/view/terraform-up-and/9781491977071/ch01.html)
over procedural shell commands.

As a final reminder, this Terraform configuration _does not_ create a Kubernetes
cluster. It only ensures the necessary AWS infrastructure for kops exists. Kops
is responsible for creating/managing our AWS cluster. For more information on
using Kops to create a cluster on AWS, see my [blog
post](http://mattjmcnaughton.com/post/a-kubernetes-of-ones-own-part-2/) on
creating a Kubernetes cluster on AWS using Kops.

## Instructions

### Prerequisites

Before beginning this tutorial, ensure the following are true:
1. Terraform is installed on your machine.
   See [download instructions](https://www.terraform.io/intro/getting-started/install.html)
   if it is not.
2. Running `aws iam get-user` returns a user. That user either has, or belongs
   to a group that has, the following policies: `AmazonEC2FullAccess`,
   `IAMFullAccess`, `AmazonS3FullAccess`, and `AmazonRoute53FullAccess`.
3. You have an S3 bucket (i.e. `USERNAME-terraform`) in which
   terraform can store its state files.
4. You own and manage a root domain (i.e. `mattjmcnaughton.com`) via Route53.
   You should see a hosted zone for your root domain in Route53.

### One-time operations

While aspects of the AWS configuration are generic (i.e. everyone will use an
iam user named `kops`), some are specific to each user. Although these variables
are not secrets, I thought it would be confusing to check them into source
control.

Instead, we define two separate `*.sample` files which illustrate the variables
you need to provide, without providing values.

The first, `provider.tf.sample`, configures where Terraform will store its state
files. Run `mv provider.tf.sample provider.tf` and then replace
"YOUR_BUCKET_FOR_STORING_TERRAFORM_STATE" with the s3 bucket we assumed you had
in step 3 of the prerequisites.

The second, `terraform.tfvars.sample`, defines the configurable aspects of the
AWS infrastructure Kops needs in order to work successfully. You need to define
three separate variables:
- `existing_base_route53_zone_name` is the existing root domain that you
  currently manage via Route53. For me, this value is `mattjmcnaughton.com.`.
- `k8s_route53_zone_name` is the new subdomain in which kops will create all of
  our Kubernetes clusters DNS records. For me, this value is `k8s.mattjmcnaughton.com.`.
- `kops_state_store_s3_bucket_name` is the name of the S3 bucket in which kops
  will store its state. For me, this value is `USERNAME-kops-state-store`.

After copying and updating the template files, run `terraform init`.

### Create/update AWS prereqs

You are now ready to create the necessary infrastructure for Kops to succeed.
First, run `terraform plan` to see what entities terraform will create. Since
you have never run `terraform apply`, terraform will need to create all the
infrastructure you declared. `terraform plan` only shows what operations
terraform would take if you ran `terraform apply`. It doesn't actually run any
of them.

To actually create the infrastructure, we need to run `terraform apply`. The
first time you run this command, terraform will create a number of new
resources.

Since terraform is declarative, you can run `terraform plan` at any point to see
if there are any differences between what your terraform configuration files
declare and what actually exists in s3. If there is, and you want to apply the
changes in the terraform configuration files, you can run `terraform apply`
again.

Should you want to delete the AWS infrastructure Kops needs, you can run
`terraform destroy`.

### Use kops

Before running `kops`, we must ensure a given set of environment variables have
the correct value. We define these variables in `env.sh`, so running `source
env.sh` ensures your current shell is ready to run `kops` commands. As an
example:

```
# Load necessary environment variables.
source env.sh

# Create initial cluster
kops create cluster --name=$NAME --state=$KOPS_STATE_STORE --zones=$AZ --ssh-public-key PATH_TO_PUBLIC_KEY
```

We store our `kops` configuration as in `kops.yaml`. This file should
always reflect the state of our kops cluster.

We can use it to updates kops configuration via `kops replace -f kops.yaml`.
Note, we still need to run `kops update cluster` as normal.

Should `kops.yaml` become out of date (which it shouldn't),
we can use `kops get $CLUSTER_NAME -o yaml > kops.yaml` to regenerate it.

### A note on reserved instances

Our current best practices for cost optimization recommend purchasing a convertible
m3.medium reserved instance from AWS. m3.medium is the size of the default
master created by kops, so after buying this reserved instance, we'll
automatically receive the billing discount. Because it is convertible, if we
need to increase the size of our master, we can "trade it in" for a more
expensive reserved instance (i.e. a reserved instance for our new master size).
Unfortunately, as far as I know, there's no way to purchase reserved instances
via Terraform. We must do it via the AWS UI. Also, note that tearing down the
cluster with `terraform destroy` will not impact our reserved instance. We are
still committed to it for X months.
