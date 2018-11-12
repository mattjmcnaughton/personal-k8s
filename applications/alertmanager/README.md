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

Additionally, one of our manifests is for a `Secret` resource. We want to store
the secret in a file (for now), so that `kubectl apply -f templates/` still
creates all necessary resources. However, we do not want to store the actual
`Secret` file in source control. As such, we make use of a `.sample` file which
we template via the `envsubst` command. Instructions for doing so can be found
below. We should run this every time we update
`alertmanager-config.yaml.sample`.

```bash
export OPSGENIE_API_KEY=...
export ALERTMANAGER_YAML_BASE64=$(cat alertmanager-config.yaml.sample | envsubst | base64 | tr -d '\n')
cat secret.yaml.sample | envsubst > secret.yaml
```

## Notes

We based this code on the manifests in [CoreOS'
kube-prometheus](https://github.com/coreos/prometheus-operator/tree/master/contrib/kube-prometheus/manifests).
