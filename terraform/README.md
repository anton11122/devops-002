# Task 1 - AWS Terraform

usage :

Tested with Terraform 1.0.3

Fill the access_key and secret_key in the variables.tf file

or export them as environment variables :

```
export AWS_ACCESS_KEY_ID="my-access-key"
export AWS_SECRET_ACCESS_KEY="my-secret-key"
```

Deploy the infrastructure:
```
terraform init
terraform plan
terraform apply
```

**Output will provide the DNS name of the ELB**

Notes:

More security could be added with providing a certificate for ELB port 443 and forwarding it to the Nginx instance.