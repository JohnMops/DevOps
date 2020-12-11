Creating an ingress resource for the application to be picked up by the ingress controller we 
install later in ../helm/nginx-ingress

Deploy ingress:

<pre><code>

kubectl apply -f guestbook-ingress.yaml

kubectl -napp get ing # check the ingress

</code></pre>

We are targeting the Service named "frontend" which is what we called the guestbook service.

I am using my own domain to prepare this ingress for future cert-manager use and DNS provider.

Strongly recommend getting a free domain and use it to make this as close to real life as possible.