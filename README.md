# Terraform-AWS
Terraform project for creating AWS EC2 instances

# VM Provisioning

### Step 1: Modify variables.tf
* Select your own region

 ```
 variable "region" {
    description = "AWS Region"
    type = string
    default = "us-east-1"   <----
}
```

* For each region there are different AMI instances, find on AWS console panel

```
variable "web_ami" {
    description = "AMI for Web instances"
    type = string
    default = "ami-05fa00d4c63e32376"   <----
}
```

* Select instance type

```
variable "web_instance_type" {
    description = "Instance type for Web instances"
    type = string
    default = "t2.micro"   <----
}
``` 

Same for variable `load_balancer`

### Step 2: Modify terraform.tfvars
Modify:
* `aws_access_key`, `aws_secret_key`
* Path to `aws_pem_key_file_path`
* `aws_key_name` 

### Step 3: Start terraform project - create EC2 instances
```bash
terraform init
terraform validate
terraform apply
```

### Step 4: Terminate EC2 instances
```bash
terraform destroy 
```