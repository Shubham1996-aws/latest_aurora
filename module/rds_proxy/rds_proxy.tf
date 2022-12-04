data "aws_kms_key" "iaac_aws_kms_key" {
  key_id = "f49a4ede-9285-4d6a-aa43-8d4c5d8d150c"
}

resource "aws_secretsmanager_secret" "iaac_rds_credentials" {
  name = "rds-credentials-terraform-iaac-devops-aws-terraform"
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id     = aws_secretsmanager_secret.iaac_rds_credentials.id
  secret_string = <<EOF
{
  "username": "${var.username}",
  "password": "${var.password}",
  "engine": "mysql",
  "host": "${var.rds_endpoint}",
  "port": 3306,
  "dbClusterIdentifier": "${var.dbClusterIdentifier}"
}
EOF
}

resource "aws_db_proxy" "iaac_aws_db_proxy" {
  name                   = "rds-proxy"
  debug_logging          = false
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = false
  role_arn               = aws_iam_role.iaac_aws_iam_role.arn
  vpc_security_group_ids = var.security_group
  vpc_subnet_ids         = var.vpc_subnet_ids

  auth {
    auth_scheme = "SECRETS"
    description = "example"
    iam_auth    = "DISABLED"
    secret_arn  = aws_secretsmanager_secret.iaac_rds_credentials.arn
  }
}

resource "aws_db_proxy_default_target_group" "db-proxy-tg" {
  db_proxy_name = aws_db_proxy.iaac_aws_db_proxy.name
  connection_pool_config {
    connection_borrow_timeout    = 120
    init_query                   = "SET x=1, y=2"
    max_connections_percent      = 100
    max_idle_connections_percent = 50
    session_pinning_filters      = ["EXCLUDE_VARIABLE_SETS"]
  }
}

resource "aws_db_proxy_target" "db-proxytarget" {
  db_cluster_identifier = var.dbClusterIdentifier
  db_proxy_name          = aws_db_proxy.iaac_aws_db_proxy.name
  target_group_name      = aws_db_proxy_default_target_group.db-proxy-tg.name
}

output "rds_proxy_endpoint" {
  value = aws_db_proxy.iaac_aws_db_proxy.endpoint
}