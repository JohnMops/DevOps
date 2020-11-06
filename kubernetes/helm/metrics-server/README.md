Link: https://github.com/helm/charts/tree/master/stable/metrics-server

Issues: https://github.com/kubernetes-sigs/metrics-server/issues

Metrics Server is a cluster-wide aggregator of resource usage data. Resource metrics are used by components like kubectl top and the Horizontal Pod Autoscaler to scale workloads.

1. Deploy:

<pre><code>

kubectl create ns monitoring

helm install metric-server stable/metrics-server -nmonitoring --values values.yaml

</code></pre>

2. Check pods: 

<pre><code>

kubectl -nmonitoring get po

</code></pre>

3. Check metrics on the cluster: 

<pre><code>

kubectl top po

kubectl top node

</code></pre>

- Upgrade: 

<pre><code>

helm upgrade --install metric-server stable/metrics-server -nmonitoring --values values.yaml

</code></pre>


- Delete:

<pre><code>

helm delete release-name -nmonitoring

</code></pre>