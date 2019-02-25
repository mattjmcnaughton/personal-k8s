# cert-manager-wrapper

Wrapper for deploying the `stable/cert-manager` chart.

### Derivations from Guiding principles

Applying namespaces to this will require some thought.

### Chart dependencies

If you update the `requirements.txt`, you must run `helm dep update`.

### Before installing helm chart

Before installing, we must do the following:

```
## IMPORTANT: you MUST install the cert-manager CRDs **before** installing the
## cert-manager Helm chart
$ kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.6/deploy/manifests/00-crds.yaml

## IMPORTANT: if you are deploying into a namespace that **already exists**,
## you MUST ensure the namespace has an additional label on it in order for
## the deployment to succeed
$ kubectl label namespace <deployment-namespace> certmanager.k8s.io/disable-validation="true"
```

Additionally, until we upgrade to k8s 1.13, we will need to apply these changes
with `--validate=false` (re https://github.com/jetstack/cert-manager/pull/1223/files).

### Notes

This doesn't work, nor is it enabled, in dev, because our local cluster cannot
be accessed externally.
