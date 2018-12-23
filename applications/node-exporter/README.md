# node-exporter

This project contains the code necessary to run the
[node-exporter](https://github.com/prometheus/node-exporter), which
makes available node metrics.

## Derivations from Guiding principles

@TODO(mattjmcnaughton) We have not yet implemented the guiding principles for
this application, so we can't discuss how it violates them.

## Notes

This code is fairly directly copied from the
[example manifests](https://github.com/coreos/prometheus-operator/tree/master/contrib/kube-prometheus/manifests)
for the Prometheus CoreOS operator.

We don't have a defined method of ensuring we stay in sync with upstream, but we
should try and check in periodically.
