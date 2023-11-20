### Build Backstage Instance Using Terraform

The backstage instance was create using terraform, based on multiple public terraform modules.

https://github.com/hieutnbk2011/backstage-demo/tree/main/terraform

**Step by step**

Setup the AWS credentials
https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration

```bash
% export AWS_ACCESS_KEY_ID="anaccesskey"
% export AWS_SECRET_ACCESS_KEY="asecretkey"
```

Create github token and add the value

https://docs.github.com/en/enterprise-server@3.6/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token

```bash
echo "github_token=xxxxxxxxxxxxxx" > github_token.auto.tfvars
```

Modify the values based on your demand.

```bash
nano terraform.auto.tfvars
```

Apply the terraform code to provision the environment 

```
terraform init
terraform apply --auto-approve
```

At the end of process, you will see this text, please use the link to build and upload the image

```bash

Outputs:

ecr_link = "xxxxxxxx.dkr.ecr.ap-southeast-2.amazonaws.com/backstage"

```
