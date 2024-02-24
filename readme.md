# Step 1
$ git clone https://github.com/Acelera-DevOps/ecs-fargate-aulafinal
$ cd ecs-fargate-aulafinal
$ cd infra
$ terraform init -backend-config="infra-prod.config"
$ terraform plan -var-file="production.tfvars"
$ terraform apply -var-file="production.tfvars"
# Step 2
$ cd ..
$ cd platform
$ terraform init -backend-config="platform-prod.config"
$ terraform plan -var-file="production.tfvars"
$ terraform apply -var-file="production.tfvars"