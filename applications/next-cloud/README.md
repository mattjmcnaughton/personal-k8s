# next-cloud

**NOTE: We have not yet deployed this application to production, but it works in
development.**

This project contains the code necessary to run
a [NextCloud](https://nextcloud.com/) instance on Kubernetes.

## Derivations from Guiding principles

@TODO(mattjmcnaughton) We have not yet implemented the guiding principles for
this application, so we can't discuss how it violates them.

## Architectures

Explain why we did this way (can for basis for blog post):

- Why only one pod?
- Why manually execute commands on boot?
- Why self-hosting postgres?

## Notes

After first deploying this application, we must manually execute a series of
commands. We can run do this with the following:

```
kubectl exec -it POD -- /bin/manual-first-boot.sh
```

Transforming `secret-values.yaml.sample` into `secret-values.yaml`.

Describe interaction with `requirements.txt`.

## TODO

Link tickets.

Update to use real passwords (before deploying for real).

@TODO(mattjmcnaughton) How to monitor via Prometheus.

@TODO(mattjmcnaughton) Some method of database backups.
