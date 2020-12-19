cert-manager runs within your Kubernetes cluster as a series of deployment resources. It utilizes CustomResourceDefinitions to configure Certificate Authorities and request certificates.

Docs: https://cert-manager.io/docs/installation/kubernetes

- In this folder we will have the values.yaml for the cert-manager helm installation and an ingress yaml for our 
application with specific annotations inside that are needed for the cer manager integration.

- For this demo you will need your own domain, hopefully you already got that one from previous demos
Install the nginx ingress controller from ../nginx-ingress folder

1. Install the nginx ingress controller from ../nginx-ingress folder

2. Install the cert manager:

<pre><code>

helm repo add jetstack https://charts.jetstack.io

kubectl create ns cert-manager

helm upgrade --install cert-manger jetstack/cert-manager -ncert-manager -f values.yaml

kubectl -ncert-manager get po # check that the pods are up and running

</code></pre>

3. Point your domain to the LB created by the controller in your DNS zone

4. Deploy the application from the local folder:

<pre><code>

cd guestbook/full-deployment/

kubectl create ns app

kubectl apply -f . 

</code></pre>

5. Deploy the cluster issuer: after filling out your details inside

<pre><code>

cd ../..

kubectl apply -n cert-manager -f cluster-issuer-prod.yaml

</code></pre>

6. Deploy the application ingress object:

<pre><code>

cd guestbook/ingress/
    
kubectl apply -f .    

</code></pre>

7. Check if the secret was created: 

<pre><code>

kubectl -napp get secret

</code></pre>

8. Access your domain via https and check the certificate in place.

- The above deployment will insure your domain is secured and the certificate is automatically renewed before the 90 days are up.
