<h1>1. Are you create resources for a fresh new AWS Account?</h1>
If Yes, please proceed to continue reading the rest of content in this section. 
If No, which mean you are creating resrouces for other enviornment, Please proceed to [Second Step : AMI Key Pair] of this section.

<h3>Step : Create new Git Branch for this client</h3>
simply create a new branch based on the master.

<h3>Step : Certificate Manager</h3>
Make sure the new AWS account has certification '*.clients.cx' approved.
to check if you have the domain issued successfully.
- go to aws certificate manager
- check List certificates
- do you have domain name as "*.clients.cx" type as "Amazon Issued" and status is "Issued"

<h3>Step : AMI Key Pair</h3>
If you are using an existing AMI for creating EC2 instance, please ignore this setep. 
create KeyPair For your ec2 instance. This will allow your ec2 instance to assign a new keypair for RDP. 

Make sure the Key Name in the following format

{Env}_UI_Key
{Env}_DB_Key

e.g if you create key pair for production enviornment.
Prod_UI_Key
Prod_DB_Key
e.g if you create key pair for staging enviornment.
Staging_UI_Key
Staging_DB_Key

<h3>Step : Create CLI User</h3>
If you already have a CLI User (IAM) which has administratorAccess and PowerUserAcess, please ignore this step.
If you lost the key and secret to the cli user, you can create another security credentials for this user. proceed to 4. Once this cli-user...

 1. Now in order to allow terraform to work on the correct AWS Account. You need to create a CLI_User in the AWS AMI.
 2. Go to the AMI, Go to Users
 3. Create a new User and name it 'cli-user' and grant it 'AdministratorAccess' and 'PowerUserAcess' 
 4. Once this cli-user is created successfully. go to the Security Credentials section for this particular user.
 5. Create a Acess Keys for AWS CLI only and store the accesskey and secret.

<h3>Step : Configure AWS CLI User to your local Machine</h3>
first, let's check if you have the proper AWS CLI profile. (To remember, profile name is freely created so you may have the profile but in different name.)

for example, we are creating a new enviornment for "<b>cxiregistry</b>". 
open a powershell on your localmachine that run with administrator.
check if you have the profile by 
      
      aws configure profile=cxiregistry

if you see there is key and secret configured, please proceed to the next section.
if you are required to setup the profile and you will need to follow the instruction to enter the access key and access secrect and region.

<h1>2. Bootstrap the terraform for new AWS Account</h1>
If your AWS account is not freshly created and has used our Terraform to created resources before. 
Please check the following S3 bucket in your AWS account.

[client_name]-terraform-state-bucket

if the bucket is exist, head to
this bucket is to use for securely store the state file for the main resource terraform.

If this AWS account is fresh created. follow the rest of content

head to the Terraform project, you will see a bootstrap folder.
open var.tf file
modify the default value for each tf variable to allow the terraform use the correct aws profile.

<b>client_name</b> : need to be as the same as your AWS Cli Profile name and has to be meaningful for your client. 
<b>client_region</b> : your aws specific region e.g 'ap-southeast-2'

Once you have setup the variable, save the file and close it and run the following commands at the folder of bootstrap.
**Important** Make sure run the powershell under /bootstrap folder otherwise it will pick up some other terraform script.

terraform init

it will create a .terraform folder in the /bootstrap folder, it just contain the resources (such as modules and plugins) that need to run the terraform script.

terraform plan

check if there are 3 resources are created. it should create the following resources

1. S3 bucket name is [client_name]-terraform-state-bucket
2. aws_s3_bucket_versioning
3. aws_s3_bucket_server_side_encryption_configuration

if everything are fine.

run the following commands

terraform apply

this command will create the S3 bucket on the AWS account. 

Now Proceed to checking if the bucket is created successfully on AWS console or using AWS CLI.


<h1>3. Create enviornment</h1>

Now proceed to the main folder, you will see you have a env-setup.ps1. simply just run this powershell script on your local machine. to make sure you have aws-cli, terraform (depends on version on the template/main.tf) install properly. if you dont have them install properly, you will encounter error running this script.

follow the script instruction:
1. enter the client name. make sure it need to be all lowercase if it's not it will be converted to all lowercase.





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
