resource "aws_security_group" "default" {
  name_prefix = "${var.namespace}"
  vpc_id      = "vpc-0ead16e33ce92713d"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.10.205.226/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# new code 

resource "aws_elasticache_subnet_group" "default" {
  name       = "${var.namespace}-cache-subnet"
  subnet_ids = ["subnet-04e5935ffcedaa88e"]
  tags = {
    Name = "Elasticache Subnet Group"
  }
  
}

resource "aws_cloudwatch_log_group" "slow_logs" {
  name = "redis-slow-logs"
}

resource "aws_cloudwatch_log_group" "engine_logs" {
  name = "redis-engine-logs"
}

resource "aws_elasticache_parameter_group" "default" {
  name        = var.namespace
  family      = var.family
  description = var.description

  tags = {
    Name = "Elasticache Parameter Group"
  }
}

resource "aws_elasticache_replication_group" "default" {
  replication_group_id          = "${var.cluster_id}"
  description = "Redis cluster for Accel prod via terraform"
  node_type = var.node_type
  port = var.port
  parameter_group_name = aws_elasticache_parameter_group.default.name
  subnet_group_name          = "${aws_elasticache_subnet_group.default.name}"
  automatic_failover_enabled = false
  security_group_ids = [aws_security_group.default.id]
  engine         = "Redis"
  num_cache_clusters = var.number_cache_clusters
  maintenance_window = var.maintenance_window
  snapshot_window = var.snapshot_window
  snapshot_retention_limit = var.snapshot_retention_limit
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  apply_immediately = var.apply_immediately
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.slow_logs.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "slow-log"
  }
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.engine_logs.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "engine-log"
  }
  tags = {
    Name = "Elasticache Replication Group"
  }
}

