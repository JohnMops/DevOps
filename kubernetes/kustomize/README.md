Kustomization is a wonderful tool that has a similar fucntion like helm in turn of controlling values and changes
in your yaml files. 

- Folder structure: 

<pre><code>

├── base
│   ├── guest-book.yaml
│   └── kustomization.yaml
└── overlay
    ├── guest-book.yaml
    └── kustomization.yaml

</code></pre>

1. Base folder: contains your yaml files that describe your k8s objects.
kustomization.yaml describes the paths and the further configurations that the tool can apply. 

<pre><code>

apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources: # resources in your base folder to take into account when building yamls
  - guest-book.yaml

</code></pre>

2. Overlay folder: contains the "patch" files to be applied to your base yamls to dynamically make changes with 
a single command. kustomization.yaml contains the following info:

<pre><code>

apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
bases: # which base yamls to take 
  - ../base # path to your base folder
patchesStrategicMerge: # the files in the overlay folder to be applied to the base (patching)
  - guest-book.yaml

</code></pre>

- Usage:

1. In the base folder I've just put our app deployment yaml

<pre><code>

- The below command will build a yaml file using the files specified in kustomization.yaml and output it for review

kustomize build 

- The below command will do the same as the above and create a yaml file if you want to 

kustomize build --output .

- The below command will simply build the deployment file and apply it to your cluster

kustomize build | kubectl apply -f -

</code></pre>

2. In the overlay folder: 

I have generated a path file by going to kustomize.io > Tutorial > Drag the deployment file to the broser > 
Clicked on a field i want to change (in this case "memory: 200Mi" in requests) and clicked on Save Patch

By running the below commands from the "overlay" folder you are taking the base file and applying the patch to it. 
As per the overlay/kustomization.yaml file, you are pointing to your base folder.

<pre><code>

- The below command will build a yaml file using the files specified in kustomization.yaml and output it for review

kustomize build 

- The below command will do the same as the above and create a yaml file if you want to 

kustomize build --output .

- The below command will simply build the deployment file and apply it to your cluster

kustomize build | kubectl apply -f -

</code></pre>

You will see your deployment redploying with the new value in "requests". 

Bottom line is that this tool can be used in your CICD pipelines to control all of your object yaml files 
and easily make changes to them while kustomize does the job for you. It eliminates the need to generate yaml files
after each change. 
