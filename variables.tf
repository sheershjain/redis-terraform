variable "vpc_cidr_block" {
  description = "The top-level CIDR block for the VPC."
  default     = "10.1.0.0/16"
}

variable "cidr_blocks" {
  description = "The CIDR blocks to create the workstations in."
#  default     = ["10.1.1.0/24"]
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "namespace" {
  description = "Default namespace"
}

variable "cluster_id" {
  description = "Id to assign the new cluster"
}

variable "public_key_path" {
  description = "Path to public key for ssh access"
  default     = "~/.ssh/id_rsa.pub"
}

variable "node_groups" {
  description = "Number of nodes groups to create in the cluster"
  default     = 1
}

variable "region" {
  description = "aws region"
}


variable "port" {
  default     = 6379
  type        = number
  description = "The port number on which each of the cache nodes will accept connections."
}



# The compute and memory capacity of the nodes in the node group (shard).
# Generally speaking, the current generation types provide more memory and computational power at lower cost
# when compared to their equivalent previous generation counterparts.
# https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/CacheNodes.SupportedTypes.html

variable "node_type" {
  type        = string
  description = "The compute and memory capacity of the nodes in the node group."
}




# Every cluster and replication group has a weekly maintenance window during which any system changes are applied.
# Specifies the weekly time range during which maintenance on the cluster is performed.
# It is specified as a range in the format ddd:hh24:mi-ddd:hh24:mi. (Example: "sun:23:00-mon:01:30")
# The minimum maintenance window is a 60 minute period.
# https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/maintenance-window.html

variable "maintenance_window" {
  default     = ""
  type        = string
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed."
}



# A period during each day when ElastiCache will begin creating a backup.
# The minimum length for the backup window is 60 minutes.
# If you do not specify a backup window, ElastiCache will assign one automatically.
# https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/backups-automatic.html

variable "snapshot_window" {
  default     = ""
  type        = string
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster."
}




# The number of days the backup will be retained in Amazon S3.
# The maximum backup retention limit is 35 days.
# If the backup retention limit is set to 0, automatic backups are disabled for the cluster.
# https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/backups-automatic.html

variable "snapshot_retention_limit" {
  default     = 0
  type        = number
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them."
}


# You can enable Multi-AZ with Automatic Failover only on Redis (cluster mode disabled) clusters that have at least
# one available read replica. Clusters without read replicas do not provide high availability or fault tolerance.
# https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/AutoFailover.html

variable "automatic_failover_enabled" {
  default     = false
  type        = bool
  description = "Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails."
}


# Redis at-rest encryption is an optional feature to increase data security by encrypting on-disk data during sync
# and backup or snapshot operations. Because there is some processing needed to encrypt and decrypt the data,
# enabling at-rest encryption can have some performance impact during these operations.
# You should benchmark your data with and without at-rest encryption to determine the performance impact for your use cases.
# https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/at-rest-encryption.html

variable "at_rest_encryption_enabled" {
  default     = false
  type        = bool
  description = "Whether to enable encryption at rest."
}




# ElastiCache in-transit encryption is an optional feature that allows you to increase the security of your data at
# its most vulnerable points—when it is in transit from one location to another. Because there is some processing
# needed to encrypt and decrypt the data at the endpoints, enabling in-transit encryption can have some performance impact.
# You should benchmark your data with and without in-transit encryption to determine the performance impact for your use cases.
# https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/in-transit-encryption.html

variable "transit_encryption_enabled" {
  default     = false
  type        = bool
  description = "Whether to enable encryption in transit."
}




# If true, this parameter causes the modifications in this request and any pending modifications to be applied,
# asynchronously and as soon as possible, regardless of the maintenance_window setting for the replication group.
# apply_immediately applies only to modifications in node type, engine version, and changing the number of nodes in a cluster.
# Other modifications, such as changing the maintenance window, are applied immediately.
# https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/Clusters.Modify.html

variable "apply_immediately" {
  default     = false
  type        = bool
  description = "Specifies whether any modifications are applied immediately, or during the next maintenance window."
}

variable "family" {
  default     = "redis7"
  type        = string
  description = "The family of the ElastiCache parameter group."
}

variable "description" {
  default     = "Managed by Terraform"
  type        = string
  description = "The description of the all resources."
}



# The number of clusters this replication group initially has.
# If automatic_failover_enabled is true, the value of this parameter must be at least 2.
# The maximum permitted value for number_cache_clusters is 6 (1 primary plus 5 replicas).
# https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/Scaling.RedisReplGrps.html

variable "number_cache_clusters" {
  type        = string
  description = "The number of cache clusters (primary and replicas) this replication group will have."
}