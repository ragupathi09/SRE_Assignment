output "load_balancer_dns_name" {
  value = aws_lb.app_lb.dns_name
}
output "subnet_id" {

  value = [aws_subnet.subnet1.id, aws_subnet.subnet2.id, aws_subnet.subnet3.id, aws_subnet.subnet4.id, aws_subnet.subnet5.id, aws_subnet.subnet6.id]


}
output "route_table_id" {
  value = aws_route_table.route1.id

}
output "vpc_id" {
  value = aws_vpc.vpcmain.id
}
# output "mysql_endpoint" {
#   value = aws_db_instance.mysql_primary.endpoint


# }

# output "redis_cluster_id" {
#   value = aws_elasticache_replication_group.redis_replication_group.replication_group_id
# }
output "aws_autoscaling_group" {
  value = aws_autoscaling_group.app_asg.name

}






