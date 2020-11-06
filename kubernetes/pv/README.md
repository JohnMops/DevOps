We can create a dedicated PV and use it in the claim but I prefer working with PVCs which will 
automatically provision a PV for us upon request.

- Deploy a pvc for redis slave and master: 

<pre><code>

kubectl apply -f redis-master-pvc.yaml

kubectl apply -f redis-slave-pvc.yaml

kubectl apply -f grafana-pvc.yaml # needed for grafana later

kubectl apply -f prometheus-pvc.yaml # needed for prometheus later

kubectl -napp get pvc # check status of pvc

</code></pre>

The fact that we mentioned those PVCs in the deployments, will insure those will be used

- Deleting PVC:

In case it gets stuck on "terminating" use this trick:

<pre><code>

kubectl patch pvc pvc_name -p '{"metadata":{"finalizers":null}}'

</code></pre>
