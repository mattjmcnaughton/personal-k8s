# grafana

This project contains the code necessary to run the
[Grafana](https://grafana.org) application we use to create useful dashboards of
our monitoring data.

## Derivations from Guiding principles

@TODO(mattjmcnaughton) We have not yet implemented the guiding principles for
this application, so we can't discuss how it violates them.

## Notes

You can transform `secret-values.yaml.sample` to
`secret-values.yaml` with the following:

```
export GRAFANA_ADMIN_PASSWORD=...
cat secret-values.yaml.sample | envsubst > secret-values.yaml
```
