Flux is a tool that automates the deployment of containers to Kubernetes. It fills the automation void that exists between building and monitoring.


Steps:

1. Install fluxctl: https://docs.fluxcd.io/en/1.21.0/references/fluxctl/

2. Create namespaces: 

<pre><code>

kubectl create ns flux \
kubectl create ns nginx \
kubectl create ns app \
kubectl create ns monitoring \

</code></pre>

3. Install Flux in your cluster (replace YOURUSER with your GitHub username):

- --gitpath: P0int the flux to where he will look at your yaml files. Flux can lookup recursively through folders

<pre><code>

# To fixate the fluxctl on its namespace to run commands agains export an environment var
export FLUX_FORWARD_NAMESPACE=flux

# Install flux to your cluster 
export GHUSER="johnmops"
fluxctl install \
--git-user=${GHUSER} \
--git-email=${GHUSER}@users.noreply.github.com \
--git-url=git@github.com:${GHUSER}/DevOps \
--git-path=kubernetes/deployments,kubernetes/pv,kubernetes/hpa,kubernetes/ingress,kubernetes/services \
--git-branch=main \
--namespace=flux | kubectl apply -f -

</code></pre>

4. Check status of flux:

<pre><code>

kubectl -n flux rollout status deployment/flux

</code></pre>

5. Flux is running on the cluster and will try to pull from the repo but it will not be successful as we did
not give him permissions to the repository.

- Generate an ssh key for flux and copy it: 

<pre><code>

fluxctl identity --k8s-fwd-ns flux

</code></pre>

- Go to your repo > Settings > Deploy Keys > Add a deploy key > Paste the key > Check "Allow write access"

6. Change anything in your yaml files and commit: 

Flux will watch the repo at a 5 minutes interval which we can control or you can make a change and sync it using: 

<pre><code>

fluxctl sync

</code></pre>

7. Check the workloads registered by flux:

<pre><code>

fluxctl list-workloads    

</code></pre>

8. Check for changes you've made