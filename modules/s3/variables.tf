variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket"
}

variable "index_document" {
  type        = string
  description = "The path to the index file"
  default     = "index.html"
}

variable "error_document" {
  type        = string
  description = "The path to the error document"
  default     = "index.html"
}

variable "env" {
  type        = string
  description = "Environment of the Infrastructure"
  default     = "dev"
}
