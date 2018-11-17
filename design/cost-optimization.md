# cost-optimization

## Goal

I would like to pay as little as personal to run my k8s server, while still
enjoying "production" level performance.

## Background and Further Information

Read [my blog post](http://mattjmcnaughton.com/post/reducing-the-cost-of-running-a-personal-k8s-cluster/).

## Design Principles

The following is a list of principles to which I should adhere in order to
cost-optimize my personal k8s cluster.

### Tag all resources

All AWS resources related to my k8s cluster should have a tag, which allows me
to easily calculate my cluster's overall resource usage. Fortunately, Kops and
Kubernetes tag the vast majority of AWS resources they create with the
`KubernetesCluster=CLUSTER_NAME` tag. The resources which Kops does not tag can
be found in [this issue](https://github.com/kubernetes/kops/issues/3358).

### All containers must specify resource requests/limits

All of my Kubernetes cluster's pod's containers must specify resource
requests/limits. This specification allows me to easily aggregate each pod's
individual requests/limits into the total resources my cluster needs.

It is important to have monitoring/alerting around pods hitting their resource
limits, either by using close to 100% of their memory or being CPU throttled for
a non-trivial period of time.

Unless there is a good reason not to, the resource request should equal the limit, which
essentially guarantees a container a certain amount of resources. If I decide to
introduce auto-scaling, I may consider over-provisioning. For now, I don't want
to deal with the complexity.

### Configure kops via code

Any kops configuration which can be tracked in source control, should be tracked
in source control. The README.md in the `bootstrap` directory describes the
process in more detail. Using source control for kops configuration positively
impacts cost-optimization because it ensures us that we have a history of our
cost-saving approaches to infrastructure and can easily recreate them.

### Regularly check in on resource consumption

We will regularly schedule a check in on our k8s cluster's resource consumption.
During this check in we'll ensure that we are utilizing all of the resources we
pay for, and also see if there's the opportunity for any other
cost-optimizations (i.e. converting AWS instance from on-demand to reserved or
spot, etc...).

See [the Github issue](https://github.com/mattjmcnaughton/personal-k8s/issues/12).

### Use SpotInstances and ReservedInstances for EC2

Use spot instances for all worker nodes, where I can make them part of an
auto-scaling group, and don't really care if an individual node is terminated.
We can easily configure worker nodes to use spot instances by setting a
`maxPrice`. By setting our `maxPrice` equal to the on-demand price, we'll
guaranteed we will always have the number of spot instances that we want.

Use reserved instances for the master node, where I know it will be around for a
long time. Note, if I'm not positive if I'll need more capacity, I can use a
"convertible" reserved instance, which allows me to upgrade it to a more
expensive reserved instance.

I should never be using on-demand instances for more than 1 or 2 months.

### Favor PVC over EBS volumes attached to nodes

Its easier to track an applications disk usage if its using its own PVC, as
opposed to mounting a volume attached to a node. As such, minimize the usage of
the EBS volumes attached to the nodes. Set up monitoring/alerts for PVC, so I
can see when they are under utilized and also see when they are nearing over
utilization.

### Use Ingress to restrict number of ELBs needed

Each ELB is relatively expensive (around $20 a month). If I gave each service
its own ELB, my costs would quickly increase by a lot. Instead, I can only use
one ELB and have it point to an Ingress. I'll then do all my routing via Ingress,
which can direct requests to the appropriate server.

Note, I haven't implemented this yet. I'll do it as part of [this
issue](https://github.com/mattjmcnaughton/personal-k8s/issues/4).
