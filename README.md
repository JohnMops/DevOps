# DevOps
Tools and Mini Projects

This is not a beginner repo but will help someone who tries to perform/install/operate different
tools and technologies.

The below is a list of tasks we will perform in this project in the best order.

- Create cluster:

1. Create via eksctl
2. Create via terraform

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

- HPA:

1. Deploy the HPA for our app after the metric-server has been initialized and is running