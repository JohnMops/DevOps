- Quick start: (no console)

1. Create VPC: copy the ID
<pre><code>
aws ec2 create-vpc --cidr-block 10.0.0.0/16 \
--tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=John}]'
</code></pre>

2. Create 3 subents: copy the IDs

<pre><code>
aws ec2 create-subnet --cidr-block 10.0.16.0/20 \
--availability-zone us-east-1a \
--vpc-id vpc-05b3af2f0ea2755ea \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=eks-private-1},{Key=kubernetes.io/cluster/<cluster_name>,Value=shared},{Key=kubernetes.io/role/internal-elb,Value=1}]' \

aws ec2 create-subnet --cidr-block 10.0.32.0/20 \
--availability-zone us-east-1b \
--vpc-id vpc-05b3af2f0ea2755ea \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=eks-private-2},{Key=kubernetes.io/cluster/<cluster_name>,Value=shared},{Key=kubernetes.io/role/internal-elb,Value=1}]' \

aws ec2 create-subnet --cidr-block 10.0.48.0/20 \
--availability-zone us-east-1c \
--vpc-id vpc-05b3af2f0ea2755ea \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=eks-public-1},{Key=kubernetes.io/cluster/<cluster_name>,Value=shared},{Key=kubernetes.io/role/elb,Value=1}]' \

aws ec2 create-subnet --cidr-block 10.0.64.0/20 \
--availability-zone us-east-1b \
--vpc-id vpc-05b3af2f0ea2755ea \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=eks-public-2},{Key=kubernetes.io/cluster/john,Value=shared},{Key=kubernetes.io/role/elb,Value=1}]' 
</code></pre>

3. Create an IGW: 
<pre><code>
aws ec2 create-internet-gateway 
aws ec2 attach-internet-gateway \
--internet-gateway-id <igw_id> \
--vpc-id vpc-05b3af2f0ea2755ea
</code></pre>

4. Create an EIP for NATGW:
<pre><code>
aws ec2 allocate-address \
--domain vpc
</code></pre>

5. Create NATGW:
<pre><code>
aws ec2 create-nat-gateway \
--subnet-id <public_subnet> \
--allocation-id <eip_id>
</code></pre>

6. Create Public RT:
<pre><code>
aws ec2 create-route-table \
--vpc-id <vpc_id> \
--tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=eks-public-rt}]'
</code></pre>

7. Create Private RT:
<pre><code>
aws ec2 create-route-table \
--vpc-id <vpc_id> \
--tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=eks-private-rt}]'
</code></pre>

8. Create route to IGW:
<pre><code>
aws ec2 create-route \
--destination-cidr-block 0.0.0.0/0 \
--gateway-id <igw_id> \
--route-table-id <public_rt_id>
</code></pre>

9. Create route to NATGW:
<pre><code>
aws ec2 create-route \
--destination-cidr-block 0.0.0.0/0 \
--nat-gateway-id <nat_gw_id> \
--route-table-id <private_rt_id>
</code></pre>

10. Associate public subnet-1 to public route:
<pre><code>
aws ec2 associate-route-table \
--route-table-id <public_rt_id> \
--subnet-id <eks-public-1-id>
</code></pre>

11. Associate public subnet-2 to public route:
<pre><code>
aws ec2 associate-route-table \
--route-table-id <public_rt_id> \
--subnet-id <eks-public-2-id>
</code></pre>

12. Associate private subnet-1 to public route:
<pre><code>
aws ec2 associate-route-table \
--route-table-id <private_rt_id> \
--subnet-id <eks-private-1-id>
</code></pre>

13. Associate private subnet-2 to public route:
<pre><code>    
aws ec2 associate-route-table \
--route-table-id <private_rt_id> \
--subnet-id <eks-private-2-id>
</code></pre>

14. Fill the create-cluster.yml with the subnet values

15. Change the below block with your own key name in each group:
<pre><code>
ssh:
  publicKeyName: eks-worker
</code></pre>

16. Run: 
<pre><code>
eksctl create cluster -f create-cluster.yml
</code></pre>

17. Run:
<pre><code>
aws eks update-kubeconfig --name <cluster_name>
</code></pre>


- Cleanup: 

1. Run:
<pre><code>
eksctl delete cluster -f create-cluster.yml
</code></pre>

2. Delete vpc
<pre><code>
aws ec2 delete-vpc --vpc-id vpc-05b3af2f0ea2755ea
</code></pre>

3. Delete subnets:
<pre><code>
aws ec2 delete-subnet --subnet-id subnet-0a6236ca45c296323
aws ec2 delete-subnet --subnet-id subnet-0219ad6857cd5921d
aws ec2 delete-subnet --subnet-id subnet-09e7da1e75b16ffba
aws ec2 delete-subnet --subnet-id subnet-04aafed8e5d16a522
</code></pre>
