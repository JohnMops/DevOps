We will use the up to date chart: ingress-nginx/ingress-nginx
Can be found in: https://github.com/kubernetes/ingress-nginx

- This will create a LoadBalancer on your cloud provider to expose a public endpoint to your cluster

1. Add the repo:

<pre><code>

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

</code></pre>

2. Fetch the values.yaml: Delete everything except the file

<pre><code>

helm fetch ingress-nginx/ingress-nginx --untar

</code></pre>

3. Deploy the ingress controller:

<pre><code>

kubectl create ns nginx

helm install release-name ingress-nginx/ingress-nginx -n nginx --values values.yaml

</code></pre>

4. Update the release when you make changes: 

<pre><code>

helm upgrade --install release-name ingress-nginx/ingress-nginx -n nginx --values values.yaml

</code></pre>

4. Check the ingress controller:

<pre><code>

kubectl -nnginx get svc

</code></pre>

Configure the values.yaml file as per your requirements. Use the documentation to 
follow the values and their purpose.

5. Point your domain to the load balancer CNAME in your DNS provider or use the CNAME to access the app

- Delete:

<pre><code>

helm delete release-name -nnginx

</code></pre>

--- Ingress controller will pick up ingresses you create that are in sync with the same 
className as your controller.

