# DevOps
Tools and Mini Projects on emphasis on AWS EKS

- This is not a beginner repo but will help someone who tries to perform/install/operate different
tools and technologies.

- The below is a list of tasks we will perform in this project in the best order.

---------------------------------------------

- Current repo has:

1. ArgoCD
2. Flux and FluxV2 (GitOps toolkit)
2. Autoscaler
3. App deployment
4. Create cluster with eksctl (infrastructure with aws cli)
5. Craete cluster with terraform
6. Helm:
    - Prometheus
    - Grafana
    - Metrics-server
    - Nginx-ingress controller
    - Cert-manager to auto provision and auto renew certificates for TLS traffic to your services
7. HPA for the application
8. Ingress for the application
9. PVCs for:
    - Application
    - DB
    - Grafana
    - Prometheus
10. Service for the application
11. GitLab-CI README with instructions on how to setup runners on your cluster
12. Kustomize
13. Helmfile for all helm charts in this repo

---------------------------------------------

- Road Map: (will be added to the below list)

1. Termination handler for spot instances
2. Local node DNS cache
3. Argo Flux
4. Vault
5. Consul 
6. Istio
7. Rancher

---------------------------------------------

- Create cluster:

1. Create via /eksctl: infrastructure via aws cli manual/script
2. Create via /terraform: infrastructure via terraform

- Autoscaler:

1. Deploy the autoscaler for k8s ASGs

- Deployments: 

1. Deploying a sample guestbook app
2. Deploying redis master
3. Deploying redis slave 

- Services:

1. Deploying the guestbook service
2. Deploying the redis master service
3. Deploying the redis slave service

- Persistent Volume:

1. Deploying a Persistent Volume Claim for the application
2. Deploying a Persistent Volume Claim for the redis master
3. Deploying a Persistent Volume Claim for the redis slave

- Helm: 

1. Deploying nginx ingress controller to expose an LB outside
2. Deploy metrics-server for HPA and future monitoring tool usage
3. Deploy cert-manager to secure your server using let's encrypt free certificates and auto renew them
4. Deploy Prometheus to scrape cluster's and app metrics
5. Deploy Grafana to visualize the metrics from prometheus

- HPA:

1. Deploy the HPA for our app after the metric-server has been initialized and is running

- ArgoCD:

1. Deploy ArgoCD into the cluster
2. Deploy your application config file
3. Review the ArgoCD UI to examine the pipeline
4. Added a helm chart sync demo for metrics-server in /helm folder with instructions

- Flux

1. Deploy flux to your cluster for managing the CD pipe
2. Follow the guide for Flux V2 to super charge your CD (helm releases and yaml files)
