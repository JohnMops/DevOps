provider "aws" {
  region                  = local.region

}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  version                = "=1.11.4"
  load_config_file       = false
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}


#########################
#####   ---EIP---   #####
#########################

//being used by the nat gateways
resource "aws_eip" "nat-ngw-eip" {
  vpc   = true
  count = local.az_count

  tags = {
    environment   = local.env
    created_by    = local.tags.created_by
  }

}


#########################
#####   ---VPC---   #####
#########################

resource "aws_vpc" "main" {
  cidr_block           = local.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    Name = "${local.env}-vpc"
    environment   = local.env
    created_by    = local.tags.created_by
  }

}

##########################
##### ---Gateways--- #####
##########################

resource "aws_nat_gateway" "natgw" {
  count                 = local.az_count // we need a ngw per private subnet
  allocation_id         = element(aws_eip.nat-ngw-eip.*.id, count.index)
  subnet_id             = element(aws_subnet.public_subnets.*.id, count.index)

  tags = {
    Name = "${local.env}-ngw-${count.index}"
    environment   = local.env
    created_by    = local.tags.created_by
  }
}

resource "aws_internet_gateway" "app_vpc_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.env}-igw"
  }
}

#########################
##### ---Routing--- #####
#########################

resource "aws_route_table" "public" {
  // we need just one route table for public internet gateway
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.env}-rt-public"
  }

}

resource "aws_route_table" "eks" {
  count  = local.az_count // we need a route table per private subnet
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.env}-rt-eks-${element(local.azs, count.index)}"
  }
}

resource "aws_route" "public_to_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.app_vpc_igw.id
}



resource "aws_route" "private_backend_nat_gateway" {
  count                  = local.az_count
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = element(aws_route_table.eks.*.id, count.index)
  nat_gateway_id         = element(aws_nat_gateway.natgw.*.id, count.index)
}


resource "aws_route_table_association" "eks" {
  count          = local.az_count
  subnet_id      = element(aws_subnet.eks_internal_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.eks.*.id, count.index)
}




resource "aws_route_table_association" "public" {
  count          = local.az_count
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public.id
}


#########################
##### ---Subnets--- #####
#########################

##### Public Subnet #####
//currently not being used , will be required once we need an ingress external internet access (to the cluster)
resource "aws_subnet" "public_subnets" {
  count                   = local.az_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(local.cidr_block, 6, count.index)
  availability_zone       = element(local.azs, count.index)

  tags = {
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    Name = "${local.env}-public-subnet-${element(local.azs, count.index)}"
  }
}

##### EKS Workers Subnet #####
resource "aws_subnet" "eks_internal_subnets" {
  count             = local.az_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(local.cidr_block, 6, count.index + 7)
  availability_zone = element(local.azs, count.index)


  tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    Name = "${local.env}-internal-subnet-${element(local.azs, count.index)}"
  }
}






module "eks" {

  source          = "terraform-aws-modules/eks/aws"

  cluster_name = local.cluster_name
  subnets = aws_subnet.eks_internal_subnets.*.id
  vpc_id = aws_vpc.main.id
  map_users       = var.map_users // "Additional IAM roles/User to add to the aws-auth configmap. See examples/basic/variables.tf for example format"
  map_roles       = var.map_roles

  worker_groups_launch_template = [for workerGroup in local.eks_worker_groups_config_initial : {
    name                    = workerGroup.name
    instance_type           = workerGroup.spot ? "" : workerGroup.instance_type
    override_instance_types = workerGroup.spot ? workerGroup.override_instance_types : null
    kubelet_extra_args      = workerGroup.kubelet_extra_args
    spot_instance_pools     = workerGroup.spot ? workerGroup.spot_instance_pools : null
    asg_desired_capacity    = workerGroup.asg_desired_capacity
    asg_min_size            = workerGroup.asg_min_size
    asg_max_size            = workerGroup.asg_max_size
    key_name                = workerGroup.key_name
    volume_size             = workerGroup.volume_size
    autoscaling_enabled     = workerGroup.autoscaling_enabled
    subnets                 = aws_subnet.eks_internal_subnets.*.id
    ebs_optimized           = false
  }]
}


