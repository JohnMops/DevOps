###Helmfile is a declarative spec for deploying helm charts. It lets you...

1. Keep a directory of chart value files and maintain changes in version control.
2. Apply CI/CD to configuration changes.
3. Periodically sync to avoid skew in environments.


!!! Important to know that helm3 does not create namespaces
You need them to exist prior applying helmfile unless your helm version is 3.2+ !!!

1. Install helmfile cli: 

Go to https://github.com/roboll/helmfile and choose the method. 

Quick mac: brew install helmfile

! helm has to be installed

1. helmfile.yaml:

- repositories block: 
    1. name: repo to add to your helm repo list
    2. url: the url of the repo to be added

Has more feature and configurations, see docs    

- releases block: 

<pre><code>

- name: nginx-ingress # name of your release
  chart: "ingress-nginx/ingress-nginx" # chart name to pull
  version: "3.19.0"   # chart version
  namespace: "nginx" # namespace to deploy to
  createNamespace: true # helm version 3.2+ #
  labels: # labels for the release
    app: nginx-ingress
  values: # the path to the custom values.yaml file. path from the helmfile location
    - "../nginx-ingress/values.yaml"

</code></pre>

A lot more configurations are available, see docs

2. apply the helmfile to deploy all the releases into your cluster: 

<pre><code>

helmfile -f PATH_TO_HELMFILE apply 

</code></pre>

#### Your releases are now applied all together and versioned. No need to run long helm commands per chart. 
