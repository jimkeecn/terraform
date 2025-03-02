# AWS Account Setup Guide

## 1. Are You Creating Resources for a Fresh AWS Account?
If **Yes**, proceed with reading the rest of this section.  
If **No** (i.e., you are creating resources for another environment), please proceed to **[Step 3: AMI Key Pair]**.

---

## Step 1: Create a New Git Branch for This Client
Create a new branch based on the `master` branch.

```sh
# Example command
git checkout -b <client_name>
```

---

## Step 2: AWS Certificate Manager
Ensure the new AWS account has the certificate `*.clients.cx` approved.
To verify if the domain is issued successfully:

1. Go to **AWS Certificate Manager**.
2. Click **List Certificates**.
3. Check if the domain name `*.clients.cx` is listed with:
   - Type: **Amazon Issued**
   - Status: **Issued**

---

## Step 3: AMI Key Pair
If you are using an existing AMI to create an EC2 instance, you may ignore this step.

Otherwise, create a Key Pair for your EC2 instance. This will allow the instance to use a new key pair for RDP access.

### Key Pair Naming Convention:
```
{Env}_UI_Key
{Env}_DB_Key
```
For example:
- **Production Environment:** `Prod_UI_Key`, `Prod_DB_Key`
- **Staging Environment:** `Staging_UI_Key`, `Staging_DB_Key`

---

## Step 4: Create a CLI User
If you already have a CLI User (IAM) with **AdministratorAccess** and **PowerUserAccess**, you may skip this step.
If you have lost the key and secret for the CLI user, create new security credentials for this user.

1. Go to **AWS IAM** → **Users**.
2. Create a new user named **cli-user**.
3. Grant the following permissions:
   - `AdministratorAccess`
   - `PowerUserAccess`
4. Once created, go to **Security Credentials** for this user.
5. Create **Access Keys** for AWS CLI usage and securely store the access key and secret.

---

## Step 5: Configure AWS CLI User on Your Local Machine
First, check if you have the appropriate AWS CLI profile. Note that the profile name is customizable.

For example, if setting up a new environment for `cxiregistry`, open **PowerShell (Admin Mode)** and run:

```sh
aws configure profile=cxiregistry
```

- If key and secret are configured, proceed to the next step.
- Otherwise, set up the profile by entering the **Access Key**, **Secret Key**, and **Region**.

---

## 2. Bootstrap the Terraform for a New AWS Account
If your AWS account is **not freshly created** and Terraform has been used before, check for the following S3 bucket:
```
[client_name]-terraform-state-bucket
```
This bucket is used for securely storing the Terraform state file.

### If This is a Fresh AWS Account
1. Navigate to the **Terraform project** and open the `bootstrap` folder.
2. Edit the `var.tf` file:
   - **client_name**: Should match your AWS CLI profile name and be meaningful.
   - **client_region**: Your AWS region (e.g., `ap-southeast-2`).
3. Save the file and run the following commands in the `/bootstrap` folder:

```sh
terraform init
```
- This initializes Terraform and creates the `.terraform` directory containing required modules and plugins.

```sh
terraform plan
```
- Verify that the following three resources will be created:
  1. S3 bucket: `[client_name]-terraform-state-bucket`
  2. `aws_s3_bucket_versioning`
  3. `aws_s3_bucket_server_side_encryption_configuration`

If everything looks correct, apply the changes:

```sh
terraform apply
```
- This creates the **S3 bucket** on the AWS account.

4. Verify the bucket is created via **AWS Console** or **AWS CLI**.

```sh
aws s3 ls
```

---

## 3. Create Environment

### (Non-PowerShell Approach)
1. For existing AWS Account, you should be able to see an env folder in the main project root.
   - if you see env project, just create the enviornment folder.
   - if you didn't see env project which means you are creating the first enviornment resource on the AWS Account.
   - Create a \env folder and then create a enviornment folder such as dev, test, prod, sandbox, stagging.
   ```
       - env\
         - prod\
   ```
2. Copy all the folder and files from template folder to the enviornment folder
   ```
       - env\
         - prod\
           - ec2\
           - iam\
           - load_balancer\
           - rest_of_folders\
           - main.tf
           - modules.tf
           - var.tf
      ```
3. start editing the var.tf file
      - **is_prod** - if the enviornment is a production enviornment, set is_prod default value to true otherwise to false.
      - **environment** - set the enviornment default value to one of (Dev, Test, Prod, Stagging, Sandbox), follow the same camel case format.
      - **client_name** - add the client_name default value such as cxi, primevalue. 
            - this primarly use to create route53 url or essential naming convention for other resources e.g s3 bucket and ec2 variable.
            - if client requires to have different or complex application URL, configure the next variable **client_force_url**
      - **client_force_url** - configure this default value if client request a special url that can be differen from the **client_name**, otherwise leave blank.
      - **client_region** configure this default value to valid AWS region such as ap-southeast-2
      - **certifcate_arn** configure this to the valid aws certificate ARN, looking for the ARN that is for *.clients.cx
      - **ui_ami_id** configure this to use existing shared UI AMI or preset AWS AMI. 
            - if you use the existing shared AMI from other AWS account, you may not need to setup the **ui_key**
            - if you use preset AWS AMI which create fresh EC2 instance, you will need to setup the **ui_key**
      - **db_ami_id** configure this to use existing shared DB AMI or preset AWS AMI. 
            - if you use the existing shared AMI from other AWS account, you may not need to setup the **db_key**
            - if you use preset AWS AMI which create fresh EC2 instance, you will need to setup the **db_key**


       



### (PowerShell Approach)
1. Navigate to the **main folder** where `env-setup.ps1` is located.
2. Run the script to ensure **AWS CLI** and **Terraform** are installed:

```sh
.\env-setup.ps1
```
3. Follow the script instructions:
   - Enter the **client name** (must be in lowercase, otherwise it will be converted automatically).

---

## Notes:
- Ensure your AWS CLI is configured correctly before running Terraform.
- The Terraform bootstrap process should always be run inside the `/bootstrap` directory to avoid conflicts with other scripts.
- Store AWS credentials securely and avoid sharing them.

---

## End of Document





### Rest are old explaination, will be removed and re-organized.
-------------------------------------------------------------------------------------------------------------
<h1>Do this before everything!!!</h1>
Make sure the new AWS account has certification '*.clients.cx' approved.
to check if you have the domain issued successfully.
- go to aws certificate manager
- check List certificates
- do you have domain name as "*.clients.cx" type as "Amazon Issued" and status is "Issued"

After the certificate is successfully issued in the new AWS Account.
Replace all "##certificate_arn##" to the exact arn in the main.tf file.
If the ARN is not properly replaced, it will throw an error saying the arn is invalid when 'terraform plan'


<h1>Create Backend.tfvars file</h1>
bucket         = "[bucket-name]" //this bucket is created within the bootstrap file. usally is the "[$clientName]-terraform-state-bucket". after bootstrap, check the bucketname to fill this field.
key            = "prod/terraform.tfstate" //Make sure this key [env]/terraform.tfstate e.g prod/terraform.tfstate | test/terraform.tfstate | dev/terraform.tfstate | staging/terraform.tfstate | sandbox/terraform.tfstate
region         = "ap-southeast-2" //match the s3 region.
encrypt        = true
use_lockfile   = true

Then run the following code in the specific env folder.
terraform init -backend-config=backend.tfvars


<h1>Must Read Before Running Terraform Script</h1>

Please make sure do the following before running the script.

1. Make sure to Add the new AWS Account Global ID to the AMI that we use in this script 
if you are using for new AWS Account or cross AWS Account or cross AWS Account
2. Make sure create two key pairs one for UI and one for Database and make sure the pem file is properly stored.
3. apply all the key pairds and AMI to the ec2 script.
4. Make sure to change all Client Name inside the route53.tf file to client's Name


<h1>Naming Rules</h1>
Resource Name : env + variableName e.g prod_vpc_root
Tag Name: Env_ + variableName e.g Prod_VPCRoot

<b>VPC</b>

prod_vpc_root

<b>Subnet</b>

prod_public_subnet
prod_private_subnet
prod_dummy_subnet


<b>Internet Gateway (igw)</b>
prod_igw_public


<b>S3 </b>
//S3 bucket Name needs to be unique. so we use clientName + env + variableName
microfin-prod-crs
microfin-prod-fatca
microfin-prod-up
etc...
//However the variable output name will be using underscore instead of hypen. e.g microfin_prod_crs

<b>TargetGroup</b>
//Since target group can only use alhabetic. so it will be CamelCase in env+protocal+TG
e.g
ProdHttpTG //[Prod] as short for Production [Http] as protocal [TG] short for TargetGroup
ProdHttpsTG //[Prod] as short for Production [Https] as protocal [TG] short for TargetGroup
