
variable "region" {
  description = "The region where this will be deployed"
  default     = "us-west-2"
}
variable "internal_cidr" {
  description = "The CIDR for the internal vpc where DynamoDB and internal Lambdas will run"
  default     = "192.168.0.0/24"
}

variable "external_cidr" {
  description = "The CIDR for the public vpc where Api Gw lambdas will run"
  default     = "192.168.0.0/24"
}

variable "azs" {
  description = "List of AZ's to create subnets in, count must match prv/pub subnets"
  type        = list
  default     = ["a", "b"]
}

variable "owner" {
  description = "Owner Name, will be appended to all resource names/tags"
}

resource "random_id" "id" {
  byte_length = 8
}

data "template_file" "prefix" {
  template = "$${owner}-$${randomid}"

  vars = {
    owner    = var.owner
    randomid = random_id.id.hex
  }
}
