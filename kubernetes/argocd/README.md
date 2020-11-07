Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes.

This repo will deploy the ArgoCD components and a definition of your app for ArgoCD to watch and sync.

This is an initial demo to get you up and running. 
For deep dive: https://argoproj.github.io/argo-cd

1. Deploy ArgoCD: 

<pre><code>

kubectl create ns argocd

kubectl apply -nargocd -f argocd.yaml

</code></pre>

2. Configure your application:

- Open app.yaml
- Fill out the source and destination (comments inside)

This deployment will set up an application pipeline inside ArgoCD (you will see the magic later)

- Deploy: 

<pre><code>

kubectl apply -f app.yaml

</code></pre>

3. You can expose ArgoCD dashboard via external service or an ingress but generally I like to 
keep those kind of things internal for security reasons.

- Port-forward:

<pre><code>

sudo kubectl -nargocd port-forward svc/argocd-server  8001:443 # choose any port on your local machine

</code></pre>

4. Access UI by going to localhost:port_number

Here you will see the magic of ArgoCD by expecting the pipeline that your app.yaml deployment has 
created. 

- Error inspection
- Yaml inspection
- Sync inspection
- Pipeline review
- Status review
- And more!

- Default username: admin
- Get the password: 

<pre><code>

kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2

</code></pre>

5. Check your deployment: 

<pre><code>

kubectl -napp get all # in this case the deployment will be in the app namespace as per the config in app.yaml

</code></pre>