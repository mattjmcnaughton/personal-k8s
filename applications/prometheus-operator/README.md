# prometheus-operator

This project contains the code necessary to run [CoreOS' Prometheus
Operator](https://github.com/coreos/prometheus-operator), which we use to create
Prometheus instances for monitoring our application.

## Derivations from Guiding principles

@TODO(mattjmcnaughton) We have not yet implemented the guiding principles for
this application, so we can't discuss how it violates them.

## Notes

We based this code on the manifests in [CoreOS'
kube-prometheus](https://github.com/coreos/prometheus-operator/tree/master/contrib/kube-prometheus/manifests).
We do not have any automated method of staying in sync with upstream, although
we should periodically ensure that we are staying up to date with the latest
versions of the CoreOS [Prometheus
Operator](https://github.com/coreos/prometheus-operator).
