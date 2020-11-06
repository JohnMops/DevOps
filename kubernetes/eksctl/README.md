- Quick start: (no console)

1. Create VPC: copy the ID
<pre><code>

aws ec2 create-vpc --cidr-block 10.0.0.0/16 \
--tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=John}]'

</code></pre>

2. Create 3 subnets: copy the IDs

<pre><code>

aws ec2 create-subnet --cidr-block 10.0.16.0/20 \
--availability-zone us-east-1a \
--vpc-id vpc-00891cacbf2dab1ec \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=eks-private-1},{Key=kubernetes.io/cluster/john,Value=shared},{Key=kubernetes.io/role/internal-elb,Value=1}]' \

aws ec2 create-subnet --cidr-block 10.0.32.0/20 \
--availability-zone us-east-1b \
--vpc-id vpc-00891cacbf2dab1ec \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=eks-private-2},{Key=kubernetes.io/cluster/john,Value=shared},{Key=kubernetes.io/role/internal-elb,Value=1}]' \

aws ec2 create-subnet --cidr-block 10.0.48.0/20 \
--availability-zone us-east-1c \
--vpc-id vpc-00891cacbf2dab1ec \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=eks-public-1},{Key=kubernetes.io/cluster/john,Value=shared},{Key=kubernetes.io/role/elb,Value=1}]' \

aws ec2 create-subnet --cidr-block 10.0.64.0/20 \
--availability-zone us-east-1b \
--vpc-id vpc-00891cacbf2dab1ec \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=eks-public-2},{Key=kubernetes.io/cluster/john,Value=shared},{Key=kubernetes.io/role/elb,Value=1}]'
 
</code></pre>

3. Create an IGW: 
<pre><code>
aws ec2 create-internet-gateway 
aws ec2 attach-internet-gateway \
--internet-gateway-id igw-01383670a616b4209 \
--vpc-id vpc-00891cacbf2dab1ec

</code></pre>

4. Create an EIP for NATGW:
<pre><code>
aws ec2 allocate-address \
--domain vpc
</code></pre>

5. Create NATGW:
<pre><code>

aws ec2 create-nat-gateway \
--subnet-id subnet-03bdbebe05fdc224f \
--allocation-id eipalloc-054576febc2435308

</code></pre>

6. Create Public RT:
<pre><code>

aws ec2 create-route-table \
--vpc-id vpc-00891cacbf2dab1ec \
--tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=eks-public-rt}]'

</code></pre>

7. Create Private RT:
<pre><code>

aws ec2 create-route-table \
--vpc-id vpc-00891cacbf2dab1ec \
--tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=eks-private-rt}]'

</code></pre>

8. Create route to IGW:
<pre><code>

aws ec2 create-route \
--destination-cidr-block 0.0.0.0/0 \
--gateway-id igw-01383670a616b4209 \
--route-table-id rtb-016878c7e19a60adc

</code></pre>

9. Create route to NATGW:
<pre><code>

aws ec2 create-route \
--destination-cidr-block 0.0.0.0/0 \
--nat-gateway-id nat-036155e4160d9f7dc \
--route-table-id rtb-04c699638f5a169be

</code></pre>

10. Associate public subnet-1 to public route:
<pre><code>

aws ec2 associate-route-table \
--route-table-id rtb-016878c7e19a60adc \
--subnet-id subnet-03bdbebe05fdc224f

</code></pre>

11. Associate public subnet-2 to public route:
<pre><code>

aws ec2 associate-route-table \
--route-table-id rtb-016878c7e19a60adc \
--subnet-id subnet-0f5a12a07d38664de

</code></pre>

12. Associate private subnet-1 to public route:
<pre><code>

aws ec2 associate-route-table \
--route-table-id rtb-04c699638f5a169be \
--subnet-id subnet-03f705d25ec4e8b2e

</code></pre>

13. Associate private subnet-2 to public route:
<pre><code>    
aws ec2 associate-route-table \
--route-table-id rtb-04c699638f5a169be \
--subnet-id subnet-0f4dc5a0cc443df2c
</code></pre>

14. Turn on auto assign public ip on public subnets:

<pre><code> 

aws ec2 modify-subnet-attribute --subnet-id subnet-03bdbebe05fdc224f \
--map-public-ip-on-launch

aws ec2 modify-subnet-attribute --subnet-id subnet-0f5a12a07d38664de \
--map-public-ip-on-launch
   
</code></pre>

15. Fill the create-cluster.yml with the subnet values and other information you want to customize.
    This will create 2 ASGs and 1 managed nodegroup for your eks cluster.

16. Change the below block with your own key name in each group:
<pre><code>
ssh:
  publicKeyName: eks-worker
</code></pre>

17. Run: 
<pre><code>
eksctl create cluster -f create-cluster.yml
</code></pre>

18. Run:
<pre><code>
aws eks update-kubeconfig --name cluster_name
</code></pre>


- Cleanup: 

1. Run:
<pre><code>
eksctl delete cluster -f create-cluster.yml
</code></pre>

2. Delete vpc
<pre><code>
aws ec2 delete-vpc --vpc-id vpc_id
</code></pre>

3. Delete subnets:
<pre><code>
aws ec2 delete-subnet --subnet-id subnet-00023b91a4c2c00eb
aws ec2 delete-subnet --subnet-id subnet-0219ad6857cd5921d
aws ec2 delete-subnet --subnet-id subnet-09e7da1e75b16ffba
aws ec2 delete-subnet --subnet-id subnet-04aafed8e5d16a522
</code></pre>
