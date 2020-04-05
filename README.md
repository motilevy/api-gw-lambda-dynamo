# API GATEWAY LAMBDA DYNAMO

This is an exercise in creating an serverless api using aws api gw, lambda and dynamodb.
It uses multiple lambda functions on purpose ...


# Overview
This api will have a list of artists and songs

* api gw with 3 methods:
    * get: lists all songs in the catalog
    * put: adds an artist and song to the catalog
    * delete: adds an artist and song to the catalog

# Design
## DynamoDB
This code will create a dynamodb table with pre populated songs by prince

## Internal  Lambdas
There are 3 internal lambdas, one per each method detailed above, these run in a
vpc with no internet access, and have an IAM role that allows access to the dynamodb
table above, the vpc hosting these lambdas also has a dynamodb endpoint

## External Lambdas
There are 3 external lambdas, one per each method detailed above, these run in a
vpc with internet access ( 1 igw and a nat gw per AZ), and have an IAM role that allows invocation of the internal lambdas.
egrees/ingress access of the lambdas is controled by NACLS

## API GW
The api GW root has 3 methods, each mapped to a lambda function above, the Api gw url is included in the Terraform outputs

## VPCs
Internal vpc: will have 2 private subnets, one per each AZ provided in `azs` variable
External vpc: will have 2 private and 2 public subnets, one per AZ provided in `azs` variable
The code will use:
* 2 x /28 subnets for private subnets
* 2 x /30 subnets for private subnets


----
# USAGE

## Build
For this exercise most of the values are hardcoded, simply create a `terraform.tfvars` with `owner=somename` and execute:
1. `terraform init`
2. `terraform apply`

## Cleanup
execute:
1. `terraform destroy`

## INPUTS
you may change the following inputs:

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| azs | Last letter of AZ's to create subnets in, this code assumes 2 Availability Zones only | `list` | `["a", "b"]` | yes |
| external\_cidr | The CIDR for the public vpc where Api Gw lambdas will run, code assumes a /24 | `any` | `192.168.1.0/24` | yes |
| internal\_cidr | The CIDR for the internal vpc where DynamoDB and internal Lambdas will run, code assumes a /24 | `any` | `192.168.0.0/24`| yes |
| owner | Owner Name, will be appended to all resource names/tags along with a random id | `any` | n/a | yes |
| region | The region where this will be deployed | `any` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| url | output "int" { value = module.internal\_lambdas.all } |

## Example tfvars
```
owner         = "moti"
internal_cidr = "192.168.0.0/24"
external_cidr = "192.168.1.0/24"
region = "us-west-2"
azs    = ["a", "b"]
```

## Consume
Once terraform is done you can use the following curls to the api:

### List a specific artist
`curl -X POST --header "Content-Type: application/json" --data '{}' https://url.of.api/get`

### List a specific artist
`curl -X POST --header "Content-Type: application/json" --data '{ "artist":"prince"}' https://url.of.api/get`

### Add a song
`curl -X POST --header "Content-Type: application/json" --data '{ "artist":"prince","song":"Nothing Compares 2 U"}' https://url.of.api/put`

### Delete a song
`curl -X POST --header "Content-Type: application/json" --data '{ "artist":"prince","song":"Nothing Compares 2 U"}' https://url.of.api/delete`

You can also test the api using ./bin/test.sh `api url`

### Word of caution ...
This code is the bare minimum to achieve this goal and is not meant to be used for
real life application, here are some of the main reasons:

1. lambdas code does not do any data validation/sanitation
2. lambdas are caped at 1rps and do not have autoscaling
3. dynamodb does not have point in time snapshots
4. terraform state file is saved localy and not to a remove backend
