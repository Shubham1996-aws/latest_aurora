output "vpc_id" {
    value = module.vpc.vpc_id
}

output "private_subnets" {
    value = module.vpc.private_subnets
}
output "rds-proxy-endpoint" {
  value = module.proxy.rds_proxy_endpoint
}