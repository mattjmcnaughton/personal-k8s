# updates

## Kubernetes cluster

### Background

- kops supports the equivalent Kubernetes minor release number. For example, use
  kops 1.12 to deploy k8s 1.12.
  - There applies to be some flex (i.e. I'm currently deploying k8s 1.12 with
    kops 1.11.1...) but its not officially supported so I want to avoid it.
- K8s supports 3 minor versions from the latest minor version. For example, if
  1.14 is the most recent minor release, than 1.14, 1.13, and 1.12 are
  supported.
- Important to be on a supported version of k8s. Since I've been running my k8s
  cluster, there've been 3 CVEs that required me to deploy a new patch.

### Upgrade strategy

- Download new Kops version (if necessary) and update `kops.yaml`. Then run
  `kops update cluster` and `kops rolling-update cluster`.

### Guidelines

- Upgrade patch IMMEDIATELY if security vuln.
- Check for patch upgrades on monthly cadence.
- Upgrade Kubernetes to latest Kops supported version whenever new kops release
  (check quarterly).
  - If kops releases significantly trail behind k8s releases, we'll need a new
    strategy.

## Applications

### Upgrade strategy

- Will be application specific.

### Guidelines

- Upgrade applications on a quarterly cadence, unless need to upgrade earlier
  for security vulnerability.
  - Make the smallest version upgrade possible to use a version which does not
    have any known security issues and will be supported until next quarter.
  - Can update image by upgrading the `image.tag` value. We should always hard
    code the `image.tag` value.
- TODO: Decide whether I should be updating Helm charts...

## Process

- Will schedule the following updates:
  - Monthly for k8s patch version: https://github.com/mattjmcnaughton/personal-k8s/issues/23
  - Quarterly for k8s minor version (roughly) and application version upgrades:
    https://github.com/mattjmcnaughton/personal-k8s/issues/24 and
    https://github.com/mattjmcnaughton/personal-k8s/issues/25
- For each upgrade, optionally write a short blog post about what has changed.
