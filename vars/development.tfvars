vpc_name = "my-vpc"
vpc_cidr = "10.0.0.0/16"
azs = ["ap-south-1a", "ap-south-1b"]
private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
name           = "test-aurora-db-mysql"
engine = "aurora-mysql"
engine_version = "5.7.mysql_aurora.2.10.2"
instance_class = "db.r6g.large"
security_group = ["sg-01260286840c02aa9"]
region = "ap-south-1"
profile = "shubham" 
cidr_blocks = ["0.0.0.0/0"]
master_username = "shubham"
master_password = "admin12345678"
snapshot_identifier = ""
