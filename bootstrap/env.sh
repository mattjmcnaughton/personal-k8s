#!/bin/bash

# Source common variables for running kops. Run before running `kops`
# operations.

# Setup the kops user.
export AWS_ACCESS_KEY_ID=$(terraform output kops_iam_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(terraform output kops_iam_access_key_secret)

# Strip the trailing period from the subdomain.
export NAME=$(terraform output k8s_subdomain | sed 's/.$//g')
export KOPS_STATE_STORE=s3://$(terraform output kops_state_store)
export AWS_REGION=us-west-2
export AZ=us-west-2a
