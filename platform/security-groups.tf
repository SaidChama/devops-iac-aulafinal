resource "aws_security_group" "ecs_ecurity_group" {
    name    = "${var.ecs_cluster_name}-SG"
    vpc_id  = data.terraform_remote_state.infra.outputs.vpc_id
    ingress {
        from_port   = 32768
        to_port     = 65535
        protocol    = "TCP"
        cidr_blocks = [data.terraform_remote_state.infra.outputs.vpc_cidr_block]
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "TCP"
        cidr_blocks = [var.internet_cidr_blocks]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [var.internet_cidr_blocks]
    }

    tags = {
        Name = "${var.ecs_cluster_name}-SG"
    }
}