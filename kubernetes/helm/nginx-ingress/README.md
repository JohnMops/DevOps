We will use the up to date chart: ingress-nginx/ingress-nginx
Can be found in: https://github.com/kubernetes/ingress-nginx

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

Configure the values.yaml file as per your requirements. Use the documentation to 
follow the values and their purpose.