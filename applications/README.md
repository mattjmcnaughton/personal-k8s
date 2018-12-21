# applications

This directory contains the configuration for all of the applications we deploy
onto our Kubernetes cluster.

## Guiding principles

*Note, this list of guiding principles is still a work in progress. I've only
deployed a few apps to my Kubernetes cluster, so I imagine there will be many
learnings as we ramp up.*

We offer the following guiding principles for the Kuberenetes configuration we
write to deploy our applications. As we work on an application, we will audit it
with respect to the given guiding principles. Once it conforms with all guiding
principles, we'll update its marker in the list above from
`guiding-principles-not-applied` to `guiding-principles-applied`.

As much as possible, we would like to enforce our guiding principles via static
analysis. Doing so is a work in progress.

### Configuration Templating/Deployment

- See the [helm-deploy.md](design/helm-deploy.md) design doc for information and
  best practices templating/deployment of manifest files.

### Labels

- All resources should have a label.
- Each resource should have (at least) the following labels:
  - `app.kubernetes.io/name`: The `application` to which it belongs (which should be the
    same as the directory in which we've specified the configuration).
  - `app.kubernetes.io/environment`: The `environment` to which the resource belongs. Available
    options are `development`, `staging`, `production` and `global`.
  - `helm.sh/chart`: The name of the chart through which we deployed this
    resource.

### Logging

- All applications should log to stdout (i.e. visible via kubectl logs...).
  - In the future, we'll configure the EFK stack for centralized logs.

### Namespaces/Environments

- Each combination of `ENVIRONMENT-APPLICATION` gets its own namespace. For
  example, `development-blog`, `production-blog`, `development-jupyterhub` are
  all namespaces we expect to see. We also define the `global` namespace for
  applications accessible by every environment. We will deploy common
  infrastructure, such as `Prometheus` and `ElasticSearch` to the `global` environment,
  resulting in the `global-prometheus` and `global-elasticsearch`, etc.
  namespaces.
- As a general rule, with the exception of the `global` namespaces, applications
  should not be able to communicate across namespaces. We will set up a
  `NetworkPolicies` to enforce this separation.
- The `development` environment should not consume any AWS resources (ELB, EBS) beyond what
  is strictly necessary to function. It is also what we will deploy to
  `minikube` for local development. The `staging` environment may consume AWS
  resources, but it will be short-running (i.e. delete it after we've validated
  whatever we wanted to, and deployed to prod).

### Pods

- All container images for pods should utilize a tag, which is not `latest`.
- All containers/pods should not run as root.
- All pods should have a health check and a readiness check.
- All pods should specify resource requests and resource limits.

### RBAC

- Each application (or perhaps each pod) should run with its own
  `ServiceAccount`. The `ServiceAccount` should be bound to `Role`. The `Role`
  should offer the least possible permissions (within reason).
- Only applications in the `global` namespace should be bound to a `ClusterRole`.

### CI/CD

@TODO(mattjmcnaughton) I'd like to have some form of CI/CD set up for
deployments. It would be particularly useful if, in certain instances, changes
to Git repos outside of this one could trigger builds of certain applications
(i.e. `blog.git` triggers a new blog deploy). At a very rough level, perhaps
each application will specify its own `Jenkinsfile` for how it should be
deployed.

### Secret Management

@TODO(mattjmcnaughton) I'm undecided if the secrets workflow described below
makes sense in the long term.

Currently, we store secrets base64 encoded in a `secret-values.yaml` file, which
is not checked into source control. We use these to create `Secret` resources in
Kubernetes via helm templating. We check a `secret-values.yaml.sample` file into
source control, which can be used as a guide for specifying the necessary
secrets.

### Security

- Each application should use a `NetworkPolicy` to limit access to only intended
  other pods. By default, only pods in the global namespace (i.e. prometheus) should be
  allowed to access. At most, only pods within the namespace and global pods should be allowed to access.
- @TODO(mattjmcnaughton) Add something around PodSecurity policy.
- @TODO(mattjmcnaughton) Container image security scanning should be a component
  of CI. I'm not exactly sure what existing technologies there are which support
  this.
- All external applications should use encrypted communication on the public
  internet (i.e. https) and have an authentication mechanism.

### Persistent Storage

- All applications running the production environment should use EBS for persistent storage.
  @TODO(mattjmcnaughton) Explore the exact pattern we should use. My guess is it
  will involve `StorageClasses` and `PersistentVolumeClaims`.

### Specifying Dependencies

- Use the `requirements.yaml` chart for both internal deps and remote deps from
  Helm charts. In general, try and minimize dependencies.

### Style Guide

- @TODO(mattjmcnaughton) Find a good style guide for Kubernetes yaml/Helm
  templates. Apply as part of CI.
- Use `kebab-case` for all file names and `camelCase` for all variable names.
- Each Kubernetes object should have its own configuration file.
- Use `.yaml` instead of `.yml`.
