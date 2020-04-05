module "internal_vpc" {
  source   = "./vpc"
  name     = "internal-vpc-${data.template_file.prefix.rendered}"
  region   = var.region
  cidr     = var.internal_cidr
  azs      = var.azs
  vpc_type = "internal"
}

module "external_vpc" {
  source   = "./vpc"
  name     = "external-vpc-${data.template_file.prefix.rendered}"
  region   = var.region
  cidr     = var.external_cidr
  azs      = var.azs
  vpc_type = "external"
}

module "music_table" {
  source = "./dynamodb"
  name   = "music-${data.template_file.prefix.rendered}"
}

module "internal_lambdas" {
  source     = "./internal_lambdas"
  name       = "music-${data.template_file.prefix.rendered}"
  table_arn  = module.music_table.arn
  table_name = module.music_table.name
  cidr       = var.internal_cidr
  vpc_id     = module.internal_vpc.id
  subnets    = module.internal_vpc.prv_subnets
}

module "external_lambdas" {
  source                = "./external_lambdas"
  name                  = "music-${data.template_file.prefix.rendered}"
  internal_lambdas_arns = module.internal_lambdas.arn_list
  cidr                  = var.external_cidr
  vpc_id                = module.external_vpc.id
  subnets               = module.external_vpc.prv_subnets
}

module "api" {
  source           = "./api"
  name             = "music-${data.template_file.prefix.rendered}"
  external_lambdas = module.external_lambdas.all
  region           = var.region
}

output "url" {
  value = module.api.url
}
