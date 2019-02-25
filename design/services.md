# services

## Overall design

By default, all services we run on Kubernetes should only be accessible within
the cluster. When we want a service to be accessible on the public internet
(i.e. blog, nextcloud), we will access it via the `*.mattjmcnaughton.com`
subdomain. All publicly accessible sites must use HTTPs.

## Technical specifics

- All `services` will have the type `ClusterIP`. We will have NO `LoadBalancer`
  services. All exposing of services to the external internet will be done via
  ingress.
- We will use the [ingress-nginx](https://github.com/kubernetes/ingress-nginx)
  ingress controller.
  - It creates a single ELB to which we will route all traffic from
    `mattjmcnaughton.com` and `*.mattjmcnaughton.com`.
- We will manage HTTPS via [cert-manager](https://github.com/jetstack/cert-manager),
  which uses LetsEncrypt.
  - We will conform to the best practices outlined in the
    [cert-manager quickstart](https://docs.cert-manager.io/en/latest/tutorials/acme/quick-start/index.html).
- We will not expose a website to the public internet unless it is intended to
  be entirely public (i.e. my blog) or has some form of authentication.
  - In the long term, it'd be great to set up 2fa.
