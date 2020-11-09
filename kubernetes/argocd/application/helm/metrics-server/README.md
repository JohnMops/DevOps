In this example we will create an ArgoCD application that will look at our metrics server chart in the git repo and 
sync it to the cluster.

1. Take a look at the folder structure of the metric-server helm chart: 

<pre><code>

metrics-server/
├── Chart.yaml
├── README.md
├── ci
│   └── ci-values.yaml
├── templates
│   ├── NOTES.txt
│   ├── _helpers.tpl
│   ├── aggregated-metrics-reader-cluster-role.yaml
│   ├── auth-delegator-crb.yaml
│   ├── cluster-role.yaml
│   ├── metric-server-service.yaml
│   ├── metrics-api-service.yaml
│   ├── metrics-server-crb.yaml
│   ├── metrics-server-deployment.yaml
│   ├── metrics-server-serviceaccount.yaml
│   ├── pdb.yaml
│   ├── psp.yaml
│   ├── role-binding.yaml
│   └── tests
│       └── test-version.yaml
└── values.yaml    

</code></pre>

- Chart is holding the information of the metrics-server chart
- templates folder have the templates for all the objects that will be created for the metrics-server
- values.yaml is our own file that we have already used previously

2. Follow the steps to install ArgoCD cli: https://argoproj.github.io/argo-cd/getting_started/

3. Get the password in case it will ask for it later: 

<pre><code>

kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2

</code></pre>

4. Port-forward the ArgoCD server to your localhost: 

<pre><code>

kubectl -n argocd port-forward svc/argocd-server -n argocd 8080:443

</code></pre>

5. Connect to the server using cli:

<pre><code>

argocd login localhost:port_number --insecure --username admin

</code></pre>

6. Creating an app via ArgoCD cli: 

<pre><code>

argocd app create metric-server --repo https://github.com/JohnMops/DevOps --path kubernetes/argocd/application/helm/metrics-server --dest-namespace kube-system --dest-server https://kubernetes.default.svc  --self-heal --sync-policy auto    

</code></pre>

7. Access UI by going to localhost:port_number

8. Check the application pipeline to see the progress

