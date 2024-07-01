Crossplane Installation and Configuration Guide

Welcome to the Crossplane installation and configuration guide! This document will walk you through the steps to install Crossplane using Helm, create a Google Cloud service account, configure IAM policies, and manage Kubernetes resources. Follow these steps to get started with Crossplane on your Kubernetes cluster.

Prerequisites

Before you begin, ensure you have the following tools installed and configured:

Helm
Google Cloud SDK (gcloud)
Kubernetes CLI (kubectl)
Step 1: Install Crossplane using Helm

First, install Crossplane in your Kubernetes cluster using Helm. This command installs Crossplane in the crossplane-system namespace and creates the namespace if it doesn't exist.

bash
Copy code
helm install crossplane \
crossplane-stable/crossplane \
--namespace crossplane-system \
--create-namespace
Step 2: Create a Google Cloud Service Account

Next, create a service account in Google Cloud. This service account will be used by Crossplane to manage Google Cloud resources.

bash
Copy code
gcloud iam service-accounts create crossplane
Step 3: Assign IAM Policies to the Service Account

Grant the necessary IAM roles to the service account. Replace YOUR_PROJECT_ID and YOUR_SERVICE_ACCOUNT_EMAIL with your actual project ID and service account email.

Storage Admin Role
bash
Copy code
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member=serviceAccount:YOUR_SERVICE_ACCOUNT_EMAIL \
  --role=roles/storage.admin
Workload Identity User Role
bash
Copy code
gcloud iam service-accounts add-iam-policy-binding \
  <Service_Account_Email_Address> \
  --role roles/iam.workloadIdentityUser \
  --member "serviceAccount:<Project_Name>.svc.id.goog[crossplane-system/<Kubernetes_Service_Account>]" \
  --project <Project_Name>
Step 4: Manage Kubernetes Resources

You can manage Kubernetes resources using kubectl. For example, to delete buckets with a specific label:

bash
Copy code
kubectl delete bucket --selector docs.crossplane.io/example=provider-gcp
Conclusion

You have successfully installed and configured Crossplane on your Kubernetes cluster. With Crossplane, you can now manage your cloud infrastructure using Kubernetes-native APIs, bringing the power of declarative configuration and extensibility to your cloud operations.

For more information and advanced configuration, visit the Crossplane documentation.