# Lambda Edge functions need to be in us-east-1
provider "aws" {
  alias  = "east_1"
  region = "us-east-1"
}
