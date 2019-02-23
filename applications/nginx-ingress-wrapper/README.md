# nginx-ingress-wrapper

Wrapper for deploying the `stable/nginx-ingress` chart. With this in place, we
can use ingress which will share a single ELB. We've set up Route53 to redirect
`mattjmcnaughton.com` and `*.mattjmcnaughton.com` to the ELB managed by ingress
created via this controller.

I believe we can have multiple `Ingress` which will all share the same IP
address.

### Derivations from Guiding principles

We haven't yet, I'm not sure if we ever will, apply resource constraints,
namespaces, etc. to this.

### Chart dependencies

If you update the `requirements.txt`, you must run `helm dep update`.

### Notes

To use this in dev, we need to ensure we have `minikube addons enable ingress`.
