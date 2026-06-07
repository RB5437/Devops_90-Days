#dev infrastructure
module "dev-infra" {
    source = "./infra-app"
    env = "dev"
    bucket_name = "rbb-infra-app-bucket"
    instance_count = 1
    instance_type = "t3.nano"
    ami_id = "ami-091138d0f0d41ff90"  #ubuntu
    hash_key = "studentID"
}

#prod infrastructure
module "prod-infra" {
    source = "./infra-app"
    env = "prod"
    bucket_name = "rbb-infra-app-bucket"
    instance_count = 2
    instance_type = "t3.micro"
    ami_id = "ami-091138d0f0d41ff90"  #ubuntu
    hash_key = "studentID"
}

#staging infrastructure
module "staging-infra" {
    source = "./infra-app"
    env = "staging"
    bucket_name = "rbb-infra-app-bucket"
    instance_count = 1
    instance_type = "t3.small"
    ami_id = "ami-091138d0f0d41ff90"  #ubuntu
    hash_key = "studentID"
}