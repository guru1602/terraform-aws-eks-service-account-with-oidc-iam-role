# terraform-aws-eks-service-account-with-oidc-iam-role
module to create service account and role 

```shell
module "module1" { 
  source = "git::git@github.com:guru1602/terraform-aws-eks-service-account-with-oidc-iam-role.git"
                 
  service_account_name        = "service-account-name"
  iam_policy_arns             = ["policy.arn"]
  kubernetes_namespace        = "namespace"
  enabled_sts_services        = ["ec2", "s3"]
  openid_connect_provider_arn = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  openid_connect_provider_url = data.aws_eks_cluster.cluster.endpoint
  cluster_name                = var.Cluster_name
  Env                         = "test"
  provision_k8s_sa            = true
}
```
