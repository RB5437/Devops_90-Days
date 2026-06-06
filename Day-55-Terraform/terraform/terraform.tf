terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "rbb-remote-s3-bucket-1"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = "true"
  }



 #backend "s3" {
    #bucket       = "rbb-remote-s3-bucket-1"
   # key          = "terraform.tfstate"
    #region       = "us-east-1"
   # dynamodb_table = "rbb-remote-dynamodb-table-1"
  #}
}

