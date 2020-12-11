Flux v2 is a powerfull upgrade and uses a GitOps toolkit for dynamic and live CD to our cluster/s.

- Installation and configuration:


1. create two new repos: Will be used for different environments deployments

  - flux-prod
  - flux-dev

You will have to take the files from my repos and push them to both repos or just fork mine so you can
make changes.

2. brew install fluxcd/tap/flux

3. Generate a github personal token in your account

### export your token and user to your local environment

export GITHUB_TOKEN=<your_token>
export GITHUB_USER=<your_user>

### check that your cluster is compatible

flux check --pre 

### Use the flux boostrap capability to install flux into your cluster automatically

flux bootstrap github \
--owner=$GITHUB_USER \
--repository=DevOps \
--branch=main \
--path=kubernetes/flux/flux-v2/flux-app \
--personal

  - This will boostrap flux to your cluster and create all the needed componenets
  - You can use a repo that does not exists and it will create it for you.
    In this case, if you fork my repo and run this command, it will create manigests and push it
    them to kubernetes/flux/flux-v2/flux-app.
    It will also create a deployment token and add it to your repo so the flux can pull files from it.

<pre><code>

kubectl -n flux-system get deploy

- Output should be:

helm-controller           1/1     1            1           6m49s
kustomize-controller      1/1     1            1           6m50s
notification-controller   1/1     1            1           6m46s
source-controller         1/1     1            1           6m51s

You should see a long output that creates all the resources

</code></pre>

-----------

1. Kustomization Controller - this controller is responsible for watching and syncing yaml files of your
application. Please see the kustomization/ folder for the demo on this tool
   
2. Helm Controller - this controller is responsible for watching and syncing helm charts.

3. Notification Controller - can be cofngiured to send notifications and alerts 

4. Source Controller - responsible for watching multiple sources and applying the objects in them to your cluster

-----------

## Let's configure deployments for app-prod and app-dev

- Prepare

<pre><code>

kubectl create ns app-prod
kubectl create ns app-dev

</code></pre>

- Create sources for prod and dev: 

  1. source - the source for flux to watch of type "git"
  2. development - the name of the source object
  3. --url : the url of this specific deployment where you have the yaml files
  4. --branch : which branch to watch on that repo
  5. --interval : interval to scan the repo   

<pre><code>

flux create source git development --url https://github.com/JohnMops/flux-dev  --branch main --interval 10s

flux create source git production --url https://github.com/JohnMops/flux-prod  --branch main --interval 10s

</code></pre>


- Create kustomizations for prod and dev:

    1. kstomization : this is an object that will actually initiate the scanning and applying
    2. development/production : name of the object
    3. --source : waht source to scan as per what we created earlier
    4. --path : what folders to watch in that source repo
    5. --prune true/false : whether to delete resources if they are no longer in that source repo
    6. --validation : validate yaml files on the source repo during the run
    7. --interval : interval to scan the repo

<pre><code>

flux create kustomization development --source development --path "./" --prune true --validation client \
--interval 10s

flux create kustomization production --source production --path "./" --prune true --validation client \
--interval 10s

</code></pre>

- Check and play: 

<pre><code>

kubectl -n app-prod get all 

kubectl -n app-dev get all

</code></pre>

You will see all the resources in the appropriate repos deployed.

- Now change whatever you want in the app-prod and dev repos and after 10 seconds check the changes. 

## You now have 1 flux that watches multiple source repos and deploys them automatically to the respective namespaces
thus achieving auto CD to different environments.

   


