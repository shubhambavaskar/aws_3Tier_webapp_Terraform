terraform {
  backend "s3" {
    bucket         = "shubham-terraform-backend"    # <<< CHANGE THIS to your bucket name
    key            = "aws_3tier/terraform.tfstate"  # path inside bucket
    region         = "ap-south-1"                   # <<< CHANGE THIS if you use another region
    dynamodb_table = "terraform-locks"              # <<< CHANGE THIS to your DynamoDB lock table name
    encrypt        = true
  }
}
