- Application Deployment

1. Create namespaces for the app:

<pre><code>

kubectl create ns app

</code></pre>

2. Deploy the app:

<pre><code>    

kubectl apply -f guest-book.yaml

kubectl -napp get po # check the pods

</code></pre>

3. Deploy redis master:

<pre><code>

kubectl apply -f redis-master.yml

kubectl -napp get po # check the pods

</code></pre>

4. Deploy redis slave:

<pre><code>

kubectl apply -f redis-slave.yml    

kubectl -napp get po # check the pods

</code></pre>

5. Port forward the app to access from the browser:

<pre><code>

kubectl -napp port-forward pod_name 80:80    

</code></pre>

6. Open browser and check localhost:80

7. Try to inout some data

8. Delete redis pods: 

<pre><code>

kubectl -napp delete po pod_name    

</code></pre>

9. Access the site again, the data will be gone

For this we will need a persistent storage to hold the data if the pods
go down. 

See ../pv folder



