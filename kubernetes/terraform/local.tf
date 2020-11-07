data "aws_availability_zones" "avz" {}

locals {
  creator = "john"
  region = "us-east-1"
  env = "test"
  cidr_block = "10.0.0.0/16"
  cluster_name = "john"
  az_count = 2
  azs = slice(data.aws_availability_zones.avz.names, 0, local.az_count)

  eks_worker_groups_config_initial = [
    {
      ### Needed for the initial deployment of pods
      "name"                    : "main",
      "asg_desired_capacity"    : "2",
      // will take affect only when creating the ASG
      "asg_min_size"            : "1",
      "asg_max_size"            : "3",
      "key_name"                : "eks-worker",
      "kubelet_extra_args"      : "--node-labels=type=cluster-system,node_role=main"
      "tags"                    : [
        {
          "key" = "k8s.io/cluster-autoscaler/node-template/label/type"
          "propagate_at_launch" = "true"
          "value" = "cluster-system"
        }],
      "volume_size"             : 30,
      "autoscaling_enabled"     : true,
      "spot"                    : true,
      "spot_instance_pools"     : 1,
      "override_instance_types" : [
        "t3.xlarge"],
    },
    {
      ### Needed for the initial deployment of pods
      "name"                    : "secondary",
      "asg_desired_capacity"    : "2",
      // will take affect only when creating the ASG
      "asg_min_size"            : "1",
      "asg_max_size"            : "3",
      "key_name"                : "eks-worker",
      "kubelet_extra_args"      : "--node-labels=type=cluster-system,node_role=secondary"
      "tags"                    : [
        {
          "key" = "k8s.io/cluster-autoscaler/node-template/label/type"
          "propagate_at_launch" = "true"
          "value" = "cluster-system"
        }],
      "volume_size"             : 30,
      "autoscaling_enabled"     : true,
      "spot"                    : true,
      "spot_instance_pools"     : 1,
      "override_instance_types" : [
        "t3.xlarge"],
    },
  ]



  tags = {
    environment = local.env
    created_by = "${local.creator}"
  }

}