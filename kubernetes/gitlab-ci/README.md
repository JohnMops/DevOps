Welcome to the world of GitOps

To begin with, we will integrate the gitlab-ci runners with our existing cluster so that your gitlab pipelines
will be able to be execute on the cluster itself. 

1. Open a new project on GitLab

2. On the left side menu go to Operations > Kubernetes

3. You can create a cluster directly from GitLab or connect an existing one

4. Click on Connect with cluster certificate > Connect existing cluster

5. Fill out everything needed according to the form: 


- Cluster name
- Environment scope 
- API URL: from console or use the command below

<pre><code>

kubectl cluster-info | grep 'Kubernetes master' | awk '/http/ {print $NF}'

</code></pre>

- CA certificate: 

<pre><code>

kubectl get secrets

kubectl get secret <secret name> -o jsonpath="{['data']['ca\.crt']}" | base64 --decode

</code></pre>

- Token: 

1. Create a file called gitlab-admin-service-account.yaml with contents:
2. Apply: 

<pre><code>

kubectl apply -f gitlab-admin-service-account.yaml

</code></pre>

3. Get the token: 

<pre><code>

kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep gitlab | awk '{print $1}')

</code></pre>

- Everything else decide according to your needs

6. On the left menu in GitLab got to Settings > Runners > Follow instruction under Specific Runners > Install on Kubernetes

7. Disable shared runners

You will see a namespace called "gitlab-managed-apps" with the pods running inside. 
Each pipeline you launch will use your cluster as its executioner.