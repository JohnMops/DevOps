create two new repos: 

1. flux-prod
2. flux-dev

brew install fluxcd/tap/flux


export GITHUB_TOKEN=<your_token>
export GITHUB_USER=<your_user>
flux check --pre # check that your cluster is compatible

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

kubectl -n flux-system get deploy

- Output should be:

helm-controller           1/1     1            1           6m49s
kustomize-controller      1/1     1            1           6m50s
notification-controller   1/1     1            1           6m46s
source-controller         1/1     1            1           6m51s

You should see a long output that creates all the resources


1. Kustomization Controller - this controller is responsible for watching and syncing yaml files of your
application.
   


