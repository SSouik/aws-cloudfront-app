# Infrastructure variables
variable "region" {
  type        = string
  description = "Qualifying AWS region (Example: us-east-2)"
  default     = "us-east-1"
}

variable "env" {
  type        = string
  description = "Environment of the Infrastructure"
  default     = "dev"
}

# App Variables

variable "domain_name" {
  type        = string
  description = "The domain name that the app will use"
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
