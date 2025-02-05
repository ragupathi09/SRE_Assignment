



# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name = "redis-subnet-group-subnet-group"

  subnet_ids = [aws_subnet.subnet3.id, aws_subnet.subnet4.id]
  tags = {
    Name = "redis-subnet-group"
  }
}




resource "aws_elasticache_replication_group" "redis_replication_group" {
  replication_group_id       = "testcluster88"
  description                = "testcluster88"
  engine                     = "redis"
  engine_version             = "6.x"
  multi_az_enabled           = true
  automatic_failover_enabled = true
  node_type                  = "cache.t3.micro"
  num_cache_clusters         = 2
  port                       = 6379
  parameter_group_name       = "default.redis6.x"
  subnet_group_name          = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids         = [aws_security_group.redis_sg.id]
  tags = {
    Name = "testcluster88"
  }

}