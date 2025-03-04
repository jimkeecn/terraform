module "s3" {
  source = "./s3"
  client_name = lower(var.client_name)
  environment = lower(var.environment)
}

module "vpc" {
  source = "./vpc"
  environment = lower(var.environment)
}

module "iam" {
  source = "./iam"
  environment = lower(var.environment)
}

module "ec2" {
  source = "./ec2"
  vpc_id              = module.vpc.vpc_id
  public_subnet_id     = module.vpc.public_subnet_id
  private_subnet_id    = module.vpc.private_subnet_id
  public_sg_id        = module.vpc.public_security_group_id
  private_sg_id       = module.vpc.private_security_group_id
  db_ec2_instance_profile_name = module.iam.db_ec2_instance_profile_name
  ui_ami_id = var.ui_ami_id
  db_ami_id = var.db_ami_id
  ui_key = var.ui_key
  db_key = var.db_key
  environment = lower(var.environment)
  client_name = lower(var.client_name)
  client_force_url = var.client_force_url
  client_region = var.client_region
}

module "route53" {
  source = "./route53"
  ui_instance_private_ip = module.ec2.ui_private_ip
  db_instance_private_ip = module.ec2.db_private_ip
  vpc_root_id = module.vpc.vpc_id
  client_name = lower(var.client_name)
  environment = lower(var.environment)
}

module "target_group"{
  source = "./targetGroup"
  vpc_root_id = module.vpc.vpc_id
  ui_instance_id = module.ec2.ui_instance_id
  db_instance_id = module.ec2.db_instance_id
  environment = lower(var.environment)
}

module "load_balancer" {
  source = "./load_balancer"
  http_tg_id = module.target_group.http_tg_id
  https_tg_id = module.target_group.https_tg_id
  vpc_root_id = module.vpc.vpc_id
  vpc_public_subnet_id = module.vpc.public_subnet_id
  vpc_dummy_subnet_id = module.vpc.dummy_subnet_id
  certifcate_arn = var.certifcate_arn
  load_balancer_security_group_id = module.vpc.load_balancer_security_group_id
  environment = lower(var.environment)
  ssl_policy = var.ssl_policy
}

module "dynamodb" {
  source = "./dynamodb"
  environment = lower(var.environment)
  client_name = lower(var.client_name)
}
