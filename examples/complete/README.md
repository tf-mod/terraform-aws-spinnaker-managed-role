# Full example of spinnaker managed role module for aws

## Usage
### Create an IAM role to target aws account

You can use this module like as below example. You can allow multiple accounts to access this spinnaker managed account by adding them into `trusted_role_arn` list. This is an example to show that target aws account allows to access from spinnaker has the IAM role `arn:aws:iam::012345678912:role/spinnaker-prod-yourapp-lxda`. Don't forget make ensure that this spinnaker role is created before applying this module to target aws account.

Please see the `spin-managed-role.tf` file for detail code.


```
module "spinnaker-managed-role" {
  source  = "tf-mod/spinnaker-managed-role/aws"
  version = "1.0.0"

  desc = "dev"
  trusted_role_arn = [
    "arn:aws:iam::012345678912:role/spinnaker-prod-yourapp-lxda",
  ]
}
```

And if you want change the parameters of this example with your own environment, you can edit terraform file (`spin-managed-role.tf`) directly or update the variables in `terraform.tfvars` file.

```
aws_account_id    = "859086152267"
aws_profile       = "my"
desc              = "dev"
```

### Add generated IAM roles to allow spinnaker access

And you have to get permission for assuming target (spinnaker managed) accounts from root in which spinnaker will be running. Here is an example. This shows you that your spinnaker will assume to `spinnaker-managed-yourapp-dev` role in `123456789123` account. And your spinnaker can assume to `spinnaker-managed-yourapp-prod` in `723456089232`. If you want to manage many AWS accounts by single spinnaker, you have to add them to `resources` list to allow assuming.

```
# assume role
data "aws_iam_policy_document" "spin-assume" {
  statement {
    actions   = ["sts:AssumeRole"]
    effect    = "Allow"
    resources = [
      "arn:aws:iam::123456789123:role/spinnaker-managed-yourapp-dev",
      "arn:aws:iam::723456089121:role/spinnaker-managed-yourapp-prod",
    ]
  }
}

resource "aws_iam_policy" "spin-assume" {
  name   = "spin-assume"
  policy = data.aws_iam_policy_document.spin-assume.json
}

resource "aws_iam_role_policy_attachment" "spin-assume" {
  policy_arn = aws_iam_policy.spin-assume.arn
  role       = aws_iam_role.spinnaker.name
}

```
