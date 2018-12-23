# alertmanager

This project contains the code necessary to run the
[Alertmanager](https://prometheus.io/docs/alerting/alertmanager/) application
which is responsible for handling alerts sent by the client (i.e. Prometheus).

## Derivations from Guiding principles

@TODO(mattjmcnaughton) We have not yet implemented the guiding principles for
this application, so we can't discuss how it violates them.

One important note is that we do not currently expose our Alertmanager to
the public internet, because we do not have `https` or any form of auth. Until
we are able to implement those, we'll use port-forwarding: `kubectl port-forward
svc/prometheus 9093:9093`.

We derivate from our normal guideline of doing base64 secret encoding via helm
templates because we are templating an entire yaml file, which is a pain. See
the Notes section below for more info.

## Notes

We based this code on the manifests in [CoreOS'
kube-prometheus](https://github.com/coreos/prometheus-operator/tree/master/contrib/kube-prometheus/manifests).

You can transform `secret-values.yaml.sample` to
`secret-values.yaml` with the following:

```
export OPSGENIE_API_KEY=...
export ALERTMANAGER_YAML_BASE64=$(cat templates/_alertmanager-config.yaml.sample | envsubst | base64 | tr -d '\n')
cat secret-values.yaml.sample | envsubst > secret-values.yaml
```

We derivate from our normal guideline of doing base64 encoding via helm
templates because we are templating an entire yaml file, which is a pain.

@TODO(mattjmcnaugthon) is this current base64 version the best method, or should
we be using Helm's files? I think probably this current version because it
allows `secret-values.yaml` as a common interface.
