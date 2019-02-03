provider "linode" {
  region  = "${var.linode_region}"
}

/* To Do:
  1- Get rid of VPC since we don't have VPC in our Linode
  2- Make sure that you have your availability zone in the server configs
*/

module "vpc" {
  source     = "./modules/vpc"
  stack_name = "${var.stack_name}"
}

/* Idea:
  Sicne we don't have database service in Linode here is my idea:
  Option 1: Use docker for database and bring it up via compose or systemd
  Option 2: bring another small instance of Linode up and configure database there
*/

module "aurora" {
  source     = "./modules/aurora"
  stack_name = "${var.stack_name}"
  subnet_ids = "${module.vpc.public_subnet_ids}"
  vpc_id     = "${module.vpc.vpc_id}"
}

/* To Do:
  1- Change all AWS Related modules data to Linode Provider
  2- Get rid of VPC since we don't have VPC in our Linode
  3- Config Outputs
*/

module "workstation" {
  source           = "./modules/workstation"
  stack_name       = "${var.stack_name}"
  vpc_id           = "${module.vpc.vpc_id}"
  public_subnet_id = "${module.vpc.public_subnet_ids[0]}"
  public_ips       = "${var.public_ips}"
}
