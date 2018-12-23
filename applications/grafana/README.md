# grafana

This project contains the code necessary to run the
[Grafana](https://grafana.org) application we use to create useful dashboards of
our monitoring data.

## Derivations from Guiding principles

@TODO(mattjmcnaughton) We have not yet implemented the guiding principles for
this application, so we can't discuss how it violates them.

One important note is that we do not currently expose our Grafana cluster to
the public internet, because we do not have `https` or any form of meaningful auth. Until
we are able to implement those, we'll use port-forwarding: `kubectl port-forward
svc/grafana 3000:3000`.

## Notes

You can transform `secret-values.yaml.sample` to
`secret-values.yaml` with the following:

```
export GRAFANA_ADMIN_PASSWORD=...
cat secret-values.yaml.sample | envsubst > secret-values.yaml
```
