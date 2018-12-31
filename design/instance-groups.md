# instance-groups

Currently, we configure three instance groups for kops. For the master, we have
the `master-us-west-2a` instance group, and for the nodes, we have the `nodes`
and `nodes-spot-instances` instance groups.

## Nodes

We use `nodes-spot-instances` because they are cheaper. However, there is a
chance they will have a couple of minutes of downtime every couple of days as a
result of being outbid for spot instances (because we cap our max bid at the
price of a on-demand instance). This downtime is only acceptable for non-HA
applications.

We enforce that only non-HA applications can run on these nodes via adding a
taint to the spot instance nodes, which non-high
availability applications must tolerate.
Specifically, we use the `type=spot-instance:NoSchedule` taint. Non-HA
applications can then tolerate this taint via specifying the following
`toleration` in the pod spec:

```
tolerations:
- key: "type"
  operator: "Equal"
  value: "spot-instance"
```

All other pods (i.e. pods belonging to HA applications,
which have not been given this toleration) will be scheduled on
the "normal" (i.e. not spot-instance) nodes.

In the medium term, we'd like to use reserved instances for our "normal" nodes.
https://github.com/mattjmcnaughton/personal-k8s/issues/16 is filed to explore
this more once we are slightly more confident in the resource needs of our HA
applications.
