# metrics-server

This project contains the code necessary to run the
[metrics-server](https://github.com/kubernetes-incubator/metrics-server), which
makes available resource usage metrics. It we must have it in place for commands
like `kubectl top` and HPA to work.

## Derivations from Guiding principles

@TODO(mattjmcnaughton) We have not yet implemented the guiding principles for
this application, so we can't discuss how it violates them.

This code is fairly directly copied from the [metrics-server
deploy](https://github.com/kubernetes-incubator/metrics-server/tree/master/deploy/1.8%2B) templates.

## Notes

This code is fairly directly copied from the [metrics-server
deploy](https://github.com/kubernetes-incubator/metrics-server/tree/master/deploy/1.8%2B) templates.

We don't have a defined method of ensuring we stay in sync with upstream, but we
should try and check in periodically.

Additionally, I'm not positive if this deploys correctly on minikube.
