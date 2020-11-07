The Kubernetes Cluster Autoscaler automatically adjusts the number of nodes in your cluster when pods fail to launch due to lack of resources or when nodes in the cluster are underutilized and their pods can be rescheduled onto other nodes in the cluster.


- Download the latest: curl -o cluster-autoscaler-autodiscover.yaml https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml

- Permissions: 

If you created the cluster with "eksctl" you do not need to add any permissions to your
node IAM roles. 

- Permissions needed in each node role: 

<pre><code>

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}

</code></pre>

1. You can control which ASGs are being watched by the autoscaler via the tags in the command section:

<pre><code>

command:
            - ./cluster-autoscaler
            - --v=4
            - --stderrthreshold=info
            - --cloud-provider=aws
            - --skip-nodes-with-local-storage=false
            - --expander=least-waste
            - --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/node-template/label/type # here <<<<<
            # Currently the same as the tags in /terraform/local.tf > eks_worker_groups_config_initial > tags

</code></pre>

2. Deploy the autoscaler: 

<pre><code>

kubectl apply -f cluster-autoscaler-autodiscover.yaml

kubectl -nkube-system get po # check the pod

kubectl -nkube-system logs pod_name # check the logs of the autoscaler

</code></pre>

- You should see the nodes being added to the tree: 

<pre><code>

I1107 07:59:47.517935       1 node_tree.go:86] Added node "ip-10-0-32-129.ec2.internal" in group "us-east-1:\x00:us-east-1b" to NodeTree
I1107 07:59:47.517983       1 node_tree.go:86] Added node "ip-10-0-33-121.ec2.internal" in group "us-east-1:\x00:us-east-1b" to NodeTree
I1107 07:59:47.518006       1 node_tree.go:86] Added node "ip-10-0-29-152.ec2.internal" in group "us-east-1:\x00:us-east-1a" to NodeTree
I1107 07:59:47.518022       1 node_tree.go:86] Added node "ip-10-0-29-39.ec2.internal" in group "us-east-1:\x00:us-east-1a" to NodeTree

</code></pre>