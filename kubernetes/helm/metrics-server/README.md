Link: https://artifacthub.io/packages/helm/bitnami/metrics-server

Issues: https://github.com/kubernetes-sigs/metrics-server/issues

Metrics Server is a cluster-wide aggregator of resource usage data. Resource metrics are used by components like kubectl top and the Horizontal Pod Autoscaler to scale workloads.

1. Deploy:

<pre><code>

helm install metric-server bitnami/metrics-server --values values.yaml

</code></pre>

2. Check pods: 

<pre><code>

kubectl get po

</code></pre>

3. Check metrics on the cluster: 

<pre><code>

kubectl top po

kubectl top node

</code></pre>

- Upgrade: 

<pre><code>

helm upgrade --install metric-server bitnami/metrics-server --values values.yaml

</code></pre>


- Delete:

<pre><code>

helm delete release-name

</code></pre>