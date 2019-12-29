# [DEPRECATED] personal-k8s

## STATUS

As of 12/19/2019, I've torn down this k8s cluster. I am now serving my blog via
my most recent self-hosting project, [nuage](https://github.com/mattjmcnaughton/nuage).
Eventually, I will likely host my own k8s cluster on `nuage`, but I will built
the cluster via `kubeadm`, instead of `kops`.

All cluster resources have been deleted via `kops` and all of the terraform
resources have been destroyed.

## Description

All the code for bootstrapping, managing, and deploying applications on my
personal k8s cluster.

## Components

Currently, this repository contains the components described below. I'll give a
brief description of the component here, but each subdirectory contains its own
`README.md` (and potentially additional documentation) with further
explanations.

- `applications`: Contains the Kubernetes configuration for all of the
  applications I'm deploying via Kubernetes.
- `bootstrap`: Contains the code for creating the AWS prerequisites for a k8s
  cluster on AWS via terraform, and helper code and instructions for creating an
  k8s cluster on AWS via terraform.

## What's Been Done So Far?

I make an effort to blog about all of the work I do with my personal k8s cluster
on [my blog](http://mattjmcnaughton.com). Here's my [original
post](http://mattjmcnaughton.com/post/a-kubernetes-of-ones-own-part-0/) on why I
decided to create my own Kubernetes cluster.

## What's coming up?

Currently, I use [Github
Issues](https://github.com/mattjmcnaughton/personal-k8s/issues)
to aggregate tickets and [Github
Projects](https://github.com/mattjmcnaughton/personal-k8s/projects/1)
to prioritize and track in progress work.

For all issues, define the **Issue**, **Implementation**, and **Definition of
Done**. The definition of done should almost always include writing a tutorial
blog post.
