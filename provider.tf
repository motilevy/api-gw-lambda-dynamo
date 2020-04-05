provider "aws" {
  version = " ~> 2.19 "
  # speed plan a bit
  skip_metadata_api_check     = true
  skip_get_ec2_platforms      = true
  skip_region_validation      = true
  skip_credentials_validation = true
}
