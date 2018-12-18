# helm-deploy

## Overall design

We should deploy all of our applications to Kubernetes via Helm charts. However,
we do not want to install Tiller on our cluster, both for security and
complexity reasons. As a result, we run `helm template APPLICATION | kubectl
apply -f -`, which allow us to use a simple `kubectl apply` based deployment
process, while retaining the expressiveness of helm templates.

## Deployment process

From the root of directory of our personal-k8s, we issue a derivation of the
following command to deploy:

```
helm template applications/APPLICATION -f applications/_helm-environments/(development.yaml|production.yaml) [-f applications/APPLICATION/secret-values.yaml] | kubectl apply -f -
```

All deployments should specify a file in `applications/_helm-environments`, but a deployment
does not to specify `-f applications/APPLICATION/secret-values.yaml` if the
application does not contain any secret values.

## Writing helm charts

We conform to the following guidelines when using helm to deploy an application.

- All charts should include a `values.yaml`. Charts may optionally include a
  `secret-values.yaml`.
  - If you include a `secret-values.yaml`, conform to the following:
    - Ensure `secret-values.yaml` is in `.helmignore`. It is already included in
      `applications/.gitignore`.
    - Create a secret-values.yaml.sample with an environment variable
      placeholder for the actual value.
      - Use `export SECRET_VALUE_BASE64=$(echo my-secret | base64 | tr -d '\n'); more secret-values.sample.yaml | envsubst > secret-values.yaml` to generate the actual secret value.
        - @TODO(mattjmcnaughton) Perhaps I should create a lightweight
          script/application to abstract this operation. Perhaps I could also
          use a base64 included in helm templating to run the helm template.
- Remove all unnecessary files from `templates`. For now, this includes
  `NOTES.txt`.
- Our `Chart.yaml` should not specify an `appVersion`.
- Our `Chart.yaml` should specify a `version`. It should start as 0.0.1, and
  increment according to semver whenever we make changes.
- All Kubernetes entities should specify the following labels at minimum:
    - `app.kubernetes.io/name: {{ include "APPLICATION.name" . }}`
    - `app.kubernetes.io/environment: {{ .Values.environment }}`
    - `helm.sh/chart: {{ include "APPLICATION.chart" . }}`
- All Kubernetes entities should specify `name: {{ include "APPLICATION.name" . }}"` and `namespace: {{ .Values.namespace }}`
- If a file or directory is prefixed with `_`, we are not actually deploying it.
  Its just a helpful state store.
- In general, any values which could change should be templated and stored in
  `values.yaml`.
