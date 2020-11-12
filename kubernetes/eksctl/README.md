- Quick start: (no console)

Either run those commands to get your hand dirty or run ./script.sh

1. Create VPC: copy the ID
<pre><code>

aws ec2 create-vpc --cidr-block 10.0.0.0/16 \
--tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=John}]'

</code></pre>

2. Create 4 subnets: copy the IDs

<pre><code>

aws ec2 create-subnet --cidr-block 10.0.16.0/20 \
--availability-zone us-east-1a \
--vpc-id vpc-0cd4db4a2b9eef19d \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=eks-private-1},{Key=kubernetes.io/cluster/john,Value=shared},{Key=kubernetes.io/role/internal-elb,Value=1}]' \

aws ec2 create-subnet --cidr-block 10.0.32.0/20 \
--availability-zone us-east-1b \
--vpc-id vpc-0cd4db4a2b9eef19d \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=eks-private-2},{Key=kubernetes.io/cluster/john,Value=shared},{Key=kubernetes.io/role/internal-elb,Value=1}]' \

aws ec2 create-subnet --cidr-block 10.0.48.0/20 \
--availability-zone us-east-1c \
--vpc-id vpc-0cd4db4a2b9eef19d \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=eks-public-1},{Key=kubernetes.io/cluster/john,Value=shared},{Key=kubernetes.io/role/elb,Value=1}]' \

aws ec2 create-subnet --cidr-block 10.0.64.0/20 \
--availability-zone us-east-1b \
--vpc-id vpc-0cd4db4a2b9eef19d \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=eks-public-2},{Key=kubernetes.io/cluster/john,Value=shared},{Key=kubernetes.io/role/elb,Value=1}]'
 
</code></pre>

3. Create an IGW: 
<pre><code>
aws ec2 create-internet-gateway 
aws ec2 attach-internet-gateway \
--internet-gateway-id igw-013419e79e46e2d2c \
--vpc-id vpc-0cd4db4a2b9eef19d

</code></pre>

4. Create an EIP for NATGW:
<pre><code>
aws ec2 allocate-address \
--domain vpc
</code></pre>

5. Create NATGW:
<pre><code>

aws ec2 create-nat-gateway \
--subnet-id subnet-0a5c0b37a9327995c \
--allocation-id eipalloc-080ad11e4c115feae

</code></pre>

6. Create Public RT:
<pre><code>

aws ec2 create-route-table \
--vpc-id vpc-0cd4db4a2b9eef19d \
--tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=eks-public-rt}]'

</code></pre>

7. Create Private RT:
<pre><code>

aws ec2 create-route-table \
--vpc-id vpc-0cd4db4a2b9eef19d \
--tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=eks-private-rt}]'

</code></pre>

8. Create route to IGW:
<pre><code>

aws ec2 create-route \
--destination-cidr-block 0.0.0.0/0 \
--gateway-id igw-013419e79e46e2d2c \
--route-table-id rtb-066e4d476a4b58baa

</code></pre>

9. Create route to NATGW:
<pre><code>

aws ec2 create-route \
--destination-cidr-block 0.0.0.0/0 \
--nat-gateway-id nat-0ed224daf3f88aa0d \
--route-table-id rtb-046fc665e346c7127

</code></pre>

10. Associate public subnet-1 to public route:
<pre><code>

aws ec2 associate-route-table \
--route-table-id rtb-066e4d476a4b58baa \
--subnet-id subnet-0a5c0b37a9327995c

</code></pre>

11. Associate public subnet-2 to public route:
<pre><code>

aws ec2 associate-route-table \
--route-table-id rtb-066e4d476a4b58baa \
--subnet-id subnet-07e2ba8a2f2c9bc04

</code></pre>

12. Associate private subnet-1 to public route:
<pre><code>

aws ec2 associate-route-table \
--route-table-id rtb-046fc665e346c7127 \
--subnet-id subnet-05f957e014ba79f10

</code></pre>

13. Associate private subnet-2 to public route:
<pre><code>    

aws ec2 associate-route-table \
--route-table-id rtb-046fc665e346c7127 \
--subnet-id subnet-07f7408b67f545cf2

</code></pre>

14. Turn on auto assign public ip on public subnets:

<pre><code> 

aws ec2 modify-subnet-attribute --subnet-id subnet-0a5c0b37a9327995c \
--map-public-ip-on-launch

aws ec2 modify-subnet-attribute --subnet-id subnet-07e2ba8a2f2c9bc04 \
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

2. Delete NATGW:

<pre><code>

aws ec2 delete-nat-gateway \
--nat-gateway-id nat-0ed224daf3f88aa0d

</code></pre>

3. Delete subnets:
<pre><code>

aws ec2 delete-subnet --subnet-id subnet-05f957e014ba79f10
aws ec2 delete-subnet --subnet-id subnet-07f7408b67f545cf2
aws ec2 delete-subnet --subnet-id subnet-0a5c0b37a9327995c
aws ec2 delete-subnet --subnet-id subnet-07e2ba8a2f2c9bc04

</code></pre>

4. Delete Route tables: 

<pre><code>

aws ec2 delete-route-table \
--route-table-id rtb-066e4d476a4b58baa

</code></pre>

5. Detach IGW:

<pre><code>

aws ec2 detach-internet-gateway \
--internet-gateway-id igw-013419e79e46e2d2c \
--vpc-id vpc-0cd4db4a2b9eef19d

</code></pre>

6. Delete IGW:

<pre><code>

aws ec2 delete-internet-gateway \
--internet-gateway-id igw-013419e79e46e2d2c

</code></pre>

7. Delete vpc
<pre><code>

aws ec2 delete-vpc --vpc-id vpc-00a4aa181bb2a46da

</code></pre>
