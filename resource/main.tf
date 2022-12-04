module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"
  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true
  enable_dns_hostnames = true

  tags = local.common_tags
}
module "cluster_creation" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.6.0"
  name           = var.name
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  create_random_password = false 
  master_username = var.master_username
  master_password = var.master_password
  publicly_accessible = true
  port = 3306
  #availability_zones = var.azs
  #snapshot_identifier = ""
  instances = {
    one = {}
    2 = {
      instance_class = var.instance_class
    }
  }

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  #allowed_security_groups = var.security_group
  allowed_cidr_blocks     = var.cidr_blocks
  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  #db_parameter_group_name         = "default"
  #db_cluster_parameter_group_name = "default"

  #enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = local.common_tags
}

#####DB cluster creation from snapshoit######
/*module "cluster_from_snapshot" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.6.0"
  name           = var.name
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  create_random_password = false 
  master_username = var.master_username
  master_password = var.master_password
  port = 3306
  #availability_zones = var.azs
  snapshot_identifier = var.snapshot_identifier
  instances = {
    one = {}
    2 = {
      instance_class = var.instance_class
    }
  }

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  #allowed_security_groups = var.security_group
  allowed_cidr_blocks     = var.cidr_blocks
  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  #db_parameter_group_name         = "default"
  #db_cluster_parameter_group_name = "default"

  enabled_cloudwatch_logs_exports = ["postgresql"]
  depends_on = [
    module.vpc
  ]

  tags = local.common_tags
}*/

module "proxy" {
  source = "../module/rds_proxy"
  username = var.master_username
  password = var.master_password
  rds_endpoint = module.cluster_creation.cluster_endpoint 
  dbClusterIdentifier = module.cluster_creation.cluster_id
  vpc_subnet_ids = module.vpc.public_subnets
  security_group =  [module.cluster_creation.security_group_id]
  depends_on = [
    module.cluster_creation
  ]
}