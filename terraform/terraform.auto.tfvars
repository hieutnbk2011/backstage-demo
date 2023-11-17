owner="hieutnbk2011"
region="ap-southeast-2"
env = "demo"

team = "devops"
createdBy = "terraform"
short_region="apse2"
availability_zones = ["ap-southeast-2a", "ap-southeast-2b","ap-southeast-2c"]
cidr_block="172.16.0.0/16"
public_subnets     = ["172.16.100.0/24", "172.16.101.0/24","172.16.102.0/24"]
app_private_subnets = ["172.16.0.0/24", "172.16.1.0/24","172.16.2.0/24"]
db_private_subnet = ["172.16.200.0/24","172.16.201.0/24"]
