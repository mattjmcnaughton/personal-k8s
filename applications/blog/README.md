# blog

This project contains the code necessary to run my
[blog](https://github.com/mattjmcnaughton/blog) on Kubernetes.

## Derivations from Guiding principles

@TODO(mattjmcnaughton) We have not yet implemented the guiding principles for
this application, so we can't discuss how it violates them.

Outside of the conventional steps for deploying an application via Kubernetes,
you also need to perform the following steps.

- Create an A record in Route53 mapping `YOURDOMAIN.com` to the
  service ELB.
