# personal-k8s

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

Please see this project's
[Roadmap](https://github.com/mattjmcnaughton/personal-k8s/projects/1) for a
prioritized list of upcoming projects.
