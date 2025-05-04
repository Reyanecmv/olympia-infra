variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "lifecycle_days" {
  description = "Number of days to keep objects"
  type        = number
  default     = 365
}