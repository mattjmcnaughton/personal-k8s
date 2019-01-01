# next-cloud

This project contains the code necessary to run
a [NextCloud](https://nextcloud.com/) instance on Kubernetes.

## Derivations from Guiding principles

@TODO(mattjmcnaughton) We have not yet implemented the guiding principles for
this application, so we can't discuss how it violates them.

## Architectures

There were a couple of architecture decisions that we debated which are worth
documenting:

### Deployment vs StatefulSet

As best I can tell, NextCloud unfortunately is a stateful application.
Specifically, it creates a `config.php` with a username/password that it creates
during the installation process. Any additional NextCloud container must have
this `config.php` file, or else NextCloud thinks it needs to redo the
installation, which will fail. However, since NextCloud itself creates this
file, we can't easily bind it as a read only volume on multiple pods.

We considered a couple different options. First, we could create a persistent
volume claim in the ReadWriteMany access mode,
meaning we'd attach the volume containing
`config.php` to many pods. We could then use a StatefulSet resource to ensure
only one pod was initializing the `config.php`, and then all remaining pods
would see it already exists and they don't need to create it. Unfortunately,
this does not work because [EBS volumes cannot be bound in the ReadWriteMany
access mode](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes)

Alternatively, we could generate the `config.php` file as a one-off job, store
it as a Kubernetes secret, and the attach it in read only mode to each pod.
This solution felt slightly too complex to be worth it.

Finally, we decided to limit our NextCloud replicas to 1, and ensure
`config.php` was written to a persistent volume in the ReadWriteOnce access
mode. With this setup, we retain `config.php` if our NextCloud pod is
terminated/killed, and don't have to do any complicated initialization steps.

We can revisit this decision if we discover there's a real need for multiple
NextCloud pods.

### Manually Executing Commands on Boot

Specifying that we need to run `kubectl exec ... some-script` whenever we first
create a new NextCloud deployment feels like a bit of an anti-pattern,
as we would like deploying NextCloud to be one-touch. However, we settled on it
because the other options had significant challenges.

We considered two other options. First, we thought about creating a `Job` which
would be responsible for executing this script. We could then execute this `Job`
when necessary (and could gate its execution via a flag in `values.yaml`).
However, we ran into the same problem as before with the multiple replica pods
for NextCloud. Our script needs `config.php` to execute, yet currently only one
pod can own `config.php`.

We also considered configuring our NextCloud pod to run this script during its
init process. However, the commands in this script will only succeed once. It
felt like a bit of an anti-pattern to be continuously running a script we expect
to fail. If we swallowed failures, there'd be the risk that we'd miss an actual
legitimate failure.

For simplicities sake, we decided to just execute the script in the currently
running pod (with the `config.php`) and trust the user to remember to run it.
Considering the user cannot log in if they do not exec the script, there seems
to be a fairly small chance of them forgetting.

### Running the backing database

We also had to decide how to run the database NextCloud needs to store state.

The simplest option would have been using Sqlite, which is what NextCloud does
by default. We could have mounted a persistent volume to wherever Sqlite writes
data, meaning loosing pod would not loose our data. However, we were fairly
considered about how using Sqlite would impact performance. We felt we needed to
use Postgres to get acceptable performance.

After deciding to use Postgres, we had two options: pay for a hosted Postgres
instance (i.e. [RDS](https://aws.amazon.com/rds/)) or self-host the database on
our Kubernetes cluster. We ultimately decided against RDS for multiple reasons.
First, it was non-trivially expensive, even if we utilized the smallest
database. Additionally, the support for creating a RDS database using Kubernetes
primitives wasn't as defined as we would like. Finally, we weren't sure if
introducing RDS would cause us to sacrifice dev/prod parity.

With these concerns in mind, we decided to at least attempt self hosting our
Postgres database on Kubernetes. We chose to deploy via the Postgresql Helm
Chart because we are already utilizing Helm as the basis for our deployments.
Another option we considered was [kubedb](https://kubedb.com/), but we had
difficultly getting it to work with a couple hours of experimentation, although
we'd be interested to examine it again.

Ultimately, while we went with self-hosted Postgresql deployed via a Helm chart,
we imagine we'll revisit this decision in the future as both the technologies we
decided against mature.

## Notes

### manual-first-boot

After first deploying this application (and more specifically the database
backing the application), we must manually execute a series of
commands to enable the necessary apps, create the non-admin users, etc.
We can do so with the following:

```
kubectl exec -it POD -- /bin/manual-first-boot.sh
```

We should only need to run this script once.

### Secrets

You can transform `secret-values.yaml.sample` to
`secret-values.yaml` with the following:

```
export NEXTCLOUD_ADMIN_USERNAME=...
export NEXTCLOUD_ADMIN_PASSWORD=...
... (see full list of environment variables in secret-values.yaml.sample)
cat secret-values.yaml.sample | envsubst > secret-values.yaml
```

### Chart dependencies

Our next-cloud chart has a dependency on the
[postgresql](https://github.com/helm/charts/tree/master/stable/postgresql)
chart. We specify the dependency via the `requirements.txt`.

If you update the `requirements.txt`, you must run `helm dep update`.

## TODO

In the interest of releasing MVPs, we deployed our NextCloud application before
it had all of the functionality we initially intended. The relevant tickets are
linked below.

- [Monitor NextCloud via Prometheus and track SLO](https://github.com/mattjmcnaughton/personal-k8s/issues/17)
- [Regular database backups for NextCloud Postgres Database](https://github.com/mattjmcnaughton/personal-k8s/issues/18)
- [Expose NextCloud on public internet, behind HTTPS](https://github.com/mattjmcnaughton/personal-k8s/issues/4)
