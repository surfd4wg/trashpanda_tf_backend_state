# trashpanda_tf_backend_state

## Description

## Creating and using the terraform backend stored in S3 and DynamoDB

Creates AWS infrastrure for managing terraform state

resources created

| Name | Purpose |
|------|---------|
| s3 | bucket to store terraform state files |
| dynamodb table | table for managing terraform state locks |
| iam | role and policy for utilizing infrastructure |

### Getting started
Pre-Reqs:
```bash
export AWS_PROFILE=<your profile>
export AWS_REGION=<your region>
export AWS_DEFAULT_REGION=<your region>
export AWS_ACCESS_KEY_ID=<your aws access key>
export AWS_SECRET_ACCESS_KEY=<your aws secret access key>
```

1. clone this repo

```bash
https://github.com/surfd4wg/trashpanda_tf_backend_state.git
```

2. navigate to the src directory, then the Step1_backend_tf_files_are_here

```bash
cd Step1_backend_tf_files_are_here
```

3. run invoke_tf.py

```bash
python invoke_tf.py -a apply -c test -p default -r us-east-1 -n "<your unique key name>/terraform.tfstate"
```

4. cd to the main terraform deployment directory
```
cd ../Step2_main_tf_files_go_here
```
Note: create your new terraform deployment in this Step2 directory, or copy your .tf files into this directory

5. cat the backend file to copy it's contents
```
cat ../Step1_backend_tf_files_are_here/s3.<region>.tfbackend

example output:
        bucket="trashpanda-us-west-2-tf-state"
        dynamodb_table="trashpanda-us-west-2-tf-state"
        region="us-west-2"
        key = "trashpanda/terraform.tfstate"
        encrypt="true"

```

6. using the output in the previous command, create a new provider.tf file, and place that content in the backend "s3 {} section
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.10.0"
    }
  }

  backend "s3" {
        bucket="trashpanda-us-west-2-tf-state"
        dynamodb_table="trashpanda-us-west-2-tf-state"
        region="us-west-2"
        key = "trashpanda/terraform.tfstate"
        encrypt="true"
        }
}

provider "aws" {
}
```

7. terraform init with the newly created backend file
```
terraform init -backend-config="../Step1_backend_tf_files_are_here/s3.<region>.tfbackend"
```

8. continue adding your additional terraform deployment files to the current directory (not the one used to create the backend). Followed by:
```
terraform init -backend-config="../Step1_backend_tf_files_are_here/s3.<region>.tfbackend"
terraform plan
terraform apply -auto-approve
etc.
```

## Destroying your terraform deployment -AND- destroying the terraform backend stored in S3 and DynamoDB
1. cd to the Step2_main_tf_files_go_here
```bash
cd Step2_main_tf_files_go_here
```
2. initiate a terraform destroy
```
terraform destroy -auto-approve
```
3. cd to the Step1_backend_tf_files_are_here
```
cd ../Step1_backend_tf_files_are_here
```
4. initiate a destroy on the s3 bucket and DynamoDB table
```
python invoke_tf.py -a destroy -c test -p default -r us-west-2 -n "<your unique key name>/terraform.tfstate"
```


## invoke_tf.py

invoke_tf.py is a python script with logic to manage executing terraform to create the backend infrastructure and manage its state. Imports class from python files in the py_modules directory

arguments

| name | switch | description |
|------|--------|-------------|
| action | -a | terraform action to perform, accepts **apply** or **destroy** |
| client | -c | owner for the terraform created resources |
| profile | -p | aws credential profile name |
| region | -r | aws account region |
| key | -n unique key name for your state file |

Todo:

Add step to migrate state to local on destroy to remove error related to releasing state lock

Init process

- Sets environment variables from profile and region to set environment variables AWS_PROFILE and AWS_REGION for terraform auth- 

- Sets variable **resource_name** used for naming terraform resources from the client and region arguments, ex **client-us-east-1-tf-state**
  
- Checks if an s3 bucket and a dynamodb table named **resource_name** exists, creates the resources if they do not exists using boto3
  
- Generates a backend config file named s3.tfbackend using the **resource_name** and **region** arguments. ex:

```bash
bucket          = "{client}-us-east-1-tf-state"
dynamodb_table  = "{client}-us-east-1-tf-state"
key             = "state/terraform.tfstate"
region          = "us-east-1"
encrypt         = true
```

- Generates terraform.tfvars file using the **client** argument to be used by terraform, ex:

```bash
client = "client"
```

- If an existing terraform state was found, runs **terraform init** using the backend config file. If not state is found, runs **terraform init** using the backend, then imports the terraform module resources for the s3 bucket and the dynamodb table into the state

- Executes terrform using the **action** argument (apply or destroy)

To use with an existing or new terraform deployment, configure the provider.tf to point to the backend, for example:
```
terraform {
  backend "s3" {
    bucket = "backend bucket name"
    dynamodb_table = "name of the dynamodb table"
    key    = "some folder name/terraform.tfstate"
    encrypt = true
    region = "region your in"
  }
}
```
