variable "do_token" {}

variable "ssh_fingerprint" {}

variable "ssh_public_key" {}

variable "instance_count" {
    default = "1"
}

variable "do_snapshot_id" {}

variable "do_name" {
    default = "jungle-hunt"
}

variable "do_region" {}

variable "do_size" {}

variable "do_private_networking" {
    default = true
}

variable "do_monitoring" {
    default = true
}

variable "do_backups" {
    default = true
}

variable "do_user" {
    default = "ryan"
}

variable "do_domain" {
    default = "@"
}

provider "digitalocean" {
    token = var.do_token
}
