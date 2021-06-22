# rkubelog

rkubelog is the easiest way to get logs out of your k8s cluster and into [Papertrail](https://www.papertrail.com/) and [Loggly](https://www.loggly.com/). Because it doesn't require DaemonSets, sidecars, fluentd or persistent claims, it's one of the only solutions for logging in nodeless clusters, such as EKS on Fargate. But it's also perfect for smaller, local dev clusters to setup logging within seconds.

## Usage

[Helm](https://helm.sh) must be installed. Please refer to Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

helm repo add ailohq https://ailohq.github.io/helm-charts

If you had already added this repo earlier, run `helm repo update` to retrieve the latest versions of the packages. You can then run `helm search repo ailohq` to see the charts.

To install the rkubelog chart:

    helm install my-rkubelog ailohq/rkubelog

To uninstall the chart:

    helm delete my-rkubelog

If you run into issues, please read the _Troubleshooting_ section at the end of this document.

### Using Papertrail

In order to ship logs to Papertrail, you will need a Papertrail account. If you don't have one already, you can sign up for one [here](https://www.papertrail.com/). After you are logged in, you will need to create a `Log Destination` from under the `Settings` menu. When a log destination is created, you will be given a host:port combo.

For any help with Papertrail, please check out their help page [here](https://documentation.solarwinds.com/en/Success_Center/papertrail/Content/papertrail_Documentation.htm).

### Using Loggly

In order to ship logs to Loggly, you will need a Loggly account. If you don't have one already you can sign up for one [here](https://www.loggly.com/). After you are logged in, you will need to create a `Customer Token` from under the `Source Setup` menu item.

For any help with Loggly, please checkout their help page [here](https://documentation.solarwinds.com/en/Success_Center/loggly/).

**Please note:** If you want to send logs to both Loggly and Papertrail, you can configure both Loggly and Papertrail related values above to valid ones. Most will only want to use one or the other.

## Development

> **Info:** You only need to reference this section if you plan to contribute to the rkubelog development.

You will need Go (1.11+) installed on your machine. Then, clone this repo to a suitable location on your machine and `cd` into it. For quick command access the project includes a Makefile.

To build run:

```
make build
```

To run the code:

```
bin/rkubelog
```

You are free to set the described environment variables or pass run time arguments described above and/or follow [kail usage guide](https://github.com/boz/kail/tree/eb6734178238dc794641e82779855fabc2071e23#usage).

To run all the static checks:

```
make lint
```

To run tests:

```
make tests
```

To create a Docker image:

```
make docker
```

# Troubleshooting

### Logs do not appear in Papertrail/Loggly after deploying rkubelog

If you deploy rkubelog on nodeless clusters, such as EKS on Fargate, you may not see logs flow immediately. Specifically on EKS on Fargate it may take up to 2 minutes for a pod to be fully deployed, as AWS needs to provision Fargate nodes. You can check the progress using:

```bash
kubectl get pods -o wide -n kube-system | grep rkubelog
```

- The "status" should be "Runnig"
- The "node" column should have a proper value (`fargate-ip-192-168-X-X.us-east-2.compute.internal`)
- The "nominated node" column should be empty

If all looks good and you still don't see logs in PT/LG, please open an issue.

### Logs suddenly stopped flowing

Please restart the rkubelog deployment:

```bash
kubectl scale deployment rkubelog --replicas=0 -n kube-system
kubectl scale deployment rkubelog --replicas=1 -n kube-system
```

If the problem persists, please open an issue.

# Releasing helm chart

```sh
export GITHUB_TOKEN=...
docker run -w /app -v (pwd):/app --entrypoint /usr/local/bin/cr quay.io/helmpack/chart-releaser package charts/rkubelog
docker run -w /app -v (pwd):/app --entrypoint /usr/local/bin/cr quay.io/helmpack/chart-releaser upload --owner ailohq --git-repo rkubelog --token $GITHUB_TOKEN
```

# Feedback

Please [open an issue](https://github.com/solarwinds/rkubelog/issues/new), we'd love to hear from you. As a SolarWinds Project, it is supported in a best-effort fashion.

# Security

If you have identified a security vulnerability, please send an email to infosec@solarwinds.com (monitored 24/7). Please do not open a public issue.
