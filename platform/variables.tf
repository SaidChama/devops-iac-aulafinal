variable "region" {
    description = "Define a região do nosso terraform"
    default = "us-east-1"
}

variable "remote_state_bucket" {
    description = "Define o nome do bucket para o remote state"
}

variable "remote_state_key" {
    description = "Define a chave para o remote state"
}

variable "ecs_cluster_name" {
    description = "Define o nome do cluster ECS"
}

variable "internet_cidr_blocks" {
    description = "Define os blocos de endereçoes de internet"
}

variable "ecs_domain_name" {
    description = "Define o nome do domínio para o ECS"
}