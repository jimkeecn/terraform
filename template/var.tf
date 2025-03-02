variable "is_prod" {
  type = bool
  default = true //Set the true if this is production env, otherwise is false
}

variable "environment" {
  description = "The environment to deploy (Dev, Test, Prod, Stagging)"
  type        = string
  default     = "" //Replace with your environment, please use CamelCase. for s3 it will auto-convert to lowercase
}

variable "client_name" {
  description = "The client name"
  type        = string
  default     = "" //Replace with your client name, also make sure this clientName is match with the AWS Profile you have in your AWS CLI because this will be used for the rest of script to genreate resources for that specific AWS Account
}

variable "client_force_url" {
  description = "The Client URL that use for route 53 if it's provided"
  type        = string
  default     = "" //Leave it blank if you don't have any specific URL for the client
}

variable "client_region" {
  description = "The client aws region"
  type        = string
  default     = "" //Replace with your aws client region
}


variable "certifcate_arn" {
  description = "The certificate arn"
  type        = string
  default = "" //Replace with your aws certificate arn
}

//AMI ID
//You need to make sure you have the AMI ID that you want to use for the EC2 instance that has account permission
variable "ui_ami_id" {
  description = "The AMI ID for the UI instance"
  type        = string
  default     = "" //Replace with your UI AMI ID that copy from the AWS console
}

variable "db_ami_id" {
  description = "The AMI ID for the DB instance"
  type        = string
  default     = "" //Replace with your DB AMI ID that copy from the AWS console
}

//Key Pair
//You need to make sure you have the key pem file or password stored securely in order to access the EC2 instance via RDP or SSH
variable "ui_key" {
  description = "The key for the UI instance"
  type        = string
  default     = "" //Replace with your UI key from the Key Pair section in the AWS console
}

variable "db_key" {
  description = "The key for the DB instance"
  type        = string
  default     = "" //Replace with your DB key from the Key Pair section in the AWS console
}


//SSL Policy
//Use for Https Load Balancer
variable "ssl_policy" {
  description = "The SSL policy"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06" //Update this policy if there is better or  the current recommanded policy from AWS e.g ELBSecurityPolicy-TLS13-1-2-2021-06
}

