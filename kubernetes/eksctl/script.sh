#! /bin/bash

cluster="john"
private_sub_list=()
public_sub_list=()

aws ec2 create-vpc --cidr-block 10.0.0.0/16 \
--tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value='"$cluster"'}]' > /dev/null

vpc=$(aws ec2 describe-vpcs --filters Name=tag:Name,Values="$cluster" --query 'Vpcs[0].VpcId' | tr -d '"')
vpc_state=$(aws ec2 describe-vpcs --filters Name=tag:Name,Values=John --query 'Vpcs[0].State')
echo "VPC ID: $vpc"
echo "VPC state: $vpc_state"


while [ "$vpc_state" == "pending" ]
do
  continue
done


aws ec2 create-subnet --cidr-block 10.0.16.0/20 \
--availability-zone us-east-1a \
--vpc-id "$vpc" \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=eks-private-1},{Key=kubernetes.io/cluster/'"$cluster"',Value=shared},{Key=kubernetes.io/role/internal-elb,Value=1}]' > /dev/null

private_1=$(aws ec2 describe-subnets --filters Name=tag:Name,Values="eks-private-1" --query 'Subnets[0].SubnetId' | tr -d '"')
echo "eks-private-1: $private_1 Zone: us-east-1a"

private_sub_list+=($private_1)

aws ec2 create-subnet --cidr-block 10.0.32.0/20 \
--availability-zone us-east-1b \
--vpc-id "$vpc" \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=eks-private-2},{Key=kubernetes.io/cluster/'"$cluster"',Value=shared},{Key=kubernetes.io/role/internal-elb,Value=1}]' > /dev/null

private_2=$(aws ec2 describe-subnets --filters Name=tag:Name,Values="eks-private-2" --query 'Subnets[0].SubnetId' | tr -d '"')
echo "eks-private-2: $private_2 Zone: us-east-1b"

private_sub_list+=($private_2)

aws ec2 create-subnet --cidr-block 10.0.48.0/20 \
--availability-zone us-east-1c \
--vpc-id "$vpc" \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=eks-public-1},{Key=kubernetes.io/cluster/'"$cluster"',Value=shared},{Key=kubernetes.io/role/elb,Value=1}]' > /dev/null

public_1=$(aws ec2 describe-subnets --filters Name=tag:Name,Values="eks-public-1" --query 'Subnets[0].SubnetId' | tr -d '"')
echo "eks-public-1: $public_1 Zone: us-east-1c"

public_sub_list+=($public_1)

aws ec2 create-subnet --cidr-block 10.0.64.0/20 \
--availability-zone us-east-1b \
--vpc-id "$vpc" \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=eks-public-2},{Key=kubernetes.io/cluster/'"$cluster"',Value=shared},{Key=kubernetes.io/role/elb,Value=1}]' > /dev/null

public_2=$(aws ec2 describe-subnets --filters Name=tag:Name,Values="eks-public-2" --query 'Subnets[0].SubnetId' | tr -d '"')
echo "eks-public-2: $public_2 Zone: us-east-1b"

public_sub_list+=($public_2)

echo "${public_sub_list[@]}"
echo "${private_sub_list[@]}"

### Create IGW

aws ec2 create-internet-gateway --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value='"$cluster"'-igw}]' > /dev/null

igw=$(aws ec2 describe-internet-gateways --filters Name=tag:Name,Values=$cluster-igw --query 'InternetGateways[0].InternetGatewayId' | tr -d '"')

echo "Attaching IGW to the VPC..."
aws ec2 attach-internet-gateway \
--internet-gateway-id "$igw" \
--vpc-id "$vpc"
echo "Attached $igw to $vpc"

### Allocate EIP for NATGW

eip=$(aws ec2 allocate-address | grep Allocation | cut -d ":" -f2 | tr -d ' ')

### Create NATGW

aws ec2 create-nat-gateway \
--subnet-id "$public_1" \
--allocation-id "$eip" \
--tag-specifications 'ResourceType=natgateway,Tags=[{Key=Name,Value='"$cluster"'}]' > /dev/null

natgw=$(aws ec2 describe-nat-gateways --filter Name=tag:Name,Values=$cluster --query 'NatGateways[0].NatGatewayId' | tr -d '"')
echo "NATGW ID: $natgw"

### Create Route tables

# Public RT

aws ec2 create-route-table \
--vpc-id "$vpc" \
--tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=eks-public-rt}]' > /dev/null

public_rt=$(aws ec2 describe-route-tables --filters Name=tag:Name,Values=eks-public-rt --query 'RouteTables[0].RouteTableId' | tr -d '"')
echo "Public Route Table: $public_rt"

# Private RT

aws ec2 create-route-table \
--vpc-id "$vpc" \
--tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=eks-private-rt}]' > /dev/null

private_rt=$(aws ec2 describe-route-tables --filters Name=tag:Name,Values=eks-private-rt --query 'RouteTables[0].RouteTableId' | tr -d '"')
echo "Public Route Table: $private_rt"

### Create routes

# Create route to IGW for public route table:

aws ec2 create-route \
--destination-cidr-block 0.0.0.0/0 \
--gateway-id "$igw" \
--route-table-id "$public_rt"

# Create route to NATGW for private route table

aws ec2 create-route \
--destination-cidr-block 0.0.0.0/0 \
--nat-gateway-id "$natgw" \
--route-table-id "$private_rt"

### Associate subnets to route tables

# Associate public subnets to public route table

for i in "${public_sub_list[@]}"
do
  aws ec2 associate-route-table \
  --route-table-id "$public_rt" \
  --subnet-id "$i"
done

# Associate private subnets to private route table

for i in "${private_sub_list[@]}"
do
  aws ec2 associate-route-table \
  --route-table-id "$private_rt" \
  --subnet-id "$i"
done

### Turn on auto assign public ip on public subnets

for i in "${public_sub_list[@]}"
do
  aws ec2 modify-subnet-attribute --subnet-id "$i" \
  --map-public-ip-on-launch
done

