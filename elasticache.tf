resource "aws_security_group" "default" {
  name_prefix = "${var.namespace}"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
  subnet_ids = "${aws_subnet.default.*.id}"
}

resource "aws_elasticache_parameter_group" "default" {
  name        = var.namespace
  family      = var.family
  description = var.description
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
}
