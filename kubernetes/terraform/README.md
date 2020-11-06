Super simple terraform to create an initial eks cluster. 

- All the variables are controlled from the local.tf file
- eks_worker_groups_config_initial has a list of nodegroup configurations. 
If you want to add more, copy paste a block into the list. 

1. Initialize: 

<pre><code>

terraform init

</code></pre>

2. Apply:

<pre><code>

terraform apply # will present a plan and ask to continue

terraform apply -auto-approve # immediate apply 

</code></pre>

- Destroy:

<pre><code>

terraform destroy # will present a plan and ask to continue

terraform destroy -auto-approve # immediate destroy

</code></pre>

