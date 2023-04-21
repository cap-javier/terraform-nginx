variable "aws_access_key" {
    type = string
    description = "AWS access key"
    sensitive = true
}

variable "aws_secret_key" {
    type = string
    description = "AWS secret key"
    sensitive = true
}

variable "aws_region" {
	type = map(string)
	description = "Todas las regiones disponibles en AWS"
	default = {
        ohio = "us-east-2"
        virginia = "us-east-1"
        california = "us-west-1"
        oregon = "us-west-2"
        cape-town = "af-south-1"
        hong-kong = "ap-east-1"
        hyderabad = "ap-south-2"
        yakarta = "ap-southeast-3"
        melbourne = "ap-southeast-4"
        mumbai = "ap-south-1"
        oasaka = "ap-northeast-3"
        seoul = "ap-northeast-2"
        singapur = "ap-southeast-1"
        sidney = "ap-southeast-2"
        tokyo = "ap-northeast-1"
        canada = "ca-central-1"
        frankfurt = "eu-central-1"
        irlanda = "eu-west-1"
        london = "eu-west-2"
        milan = "eu-south-1"
        paris = "eu-west-3"
        españa = "eu-south-2"
        estocolmo = "eu-north-1"
        zurich = "eu-central-2"
        barein = "me-south-1"
        EAU = "me-central-1"
        sao-paulo = "sa-east-1"
	}
}

variable "aws_instance_sizes" {
	type = map(string)
	description = "Region to use for AWS resources"
	default = {
		small = "t2.micro"
		medium = "t2.small"
		large = "t2.large"
	}
}

variable "ingress_port_mapping" {
    type = number
    description = "Puertos de la maquina"
    sensitive = true
    default = 80
}

variable "vpc_subnets_cidr_block" {
    type = list(string)
    description = "Lista de las subredes de las maquinas."
    default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "company" {
    type = string
    description = "Company name for resource tagging"
    default = "Globomantics"
}

variable "project" {
    type = string
    description = "Project name for resource tagging"
}

variable "billing_code" {
    type = string
    description = "Billing code for resource tagging"
}

variable "vpc_block" {
    type = string
    description = "VPC"
    sensitive = true
    default = "10.0.0.0/16"
}
