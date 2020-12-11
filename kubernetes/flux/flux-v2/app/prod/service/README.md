In deployments, we deployd the objects without exposing them.

- Service

1. Deploy app service:

<pre><code>

kubectl apply -f guest-book-service.yaml

kubectl -napp get svc #check service

</code></pre>

2. Deploy redis master service:

<pre><code>

kubectl apply -f redis-master-service.yaml

kubectl -napp get svc #check service

</code></pre>

3. Deploy redis slave service:

<pre><code>

kubectl apply -f redis-slave-service.yaml

kubectl -napp get svc #check service

</code></pre>