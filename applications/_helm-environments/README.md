# _helm-environments

As the `_` prefix indicates, `_helm-environments` is not an actual application
that we deploy. Rather, it is a store for variables we want to share across
Kubernetes applications in the same environment. Each run of `helm template`
should contain at least one of these files included via `-f`.

See [helm-deploy.md](design/helm-deploy.md) for more info.
