provider "aws" {
  region = "us-east-1"
  profile = "dbmigration"
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-1a"
}

resource "aws_ecs_cluster" "db_deployment" {
  name = "db-deployment-cluster"
}

resource "aws_ecs_task_definition" "db_deployment" {
  container_definitions = "${file("./db-migration-container-definitions.json")}"
  family = "db-deployment-definition"
  cpu = "256"
  memory = "512"
  network_mode = "awsvpc"
  requires_compatibilities = [
    "FARGATE"
  ]

  execution_role_arn = "arn:aws:iam::114795752263:role/ecsTaskExecutionRole"

  depends_on = [
    "aws_ecs_cluster.db_deployment"
  ]

  //  provisioner "local-exec" {
  //    command = "aws ecs run-task --cluster ${aws_ecs_cluster.db_deployment.arn} --task-definition ${aws_ecs_task_definition.db_deployment.arn} --network-configuration 'awsvpcConfiguration={subnets=[${aws_default_subnet.default_az1.id}],assignPublicIp=ENABLED}' --launch-type=FARGATE --profile dbmigration --region us-east-1"
  // }
}

output "cluster_arn" {
  value = "${aws_ecs_cluster.db_deployment.arn}"
}

output "task_definition_arn" {
  value = "${aws_ecs_task_definition.db_deployment.arn}"
}

output "default_subnet_id" {
  value = "${aws_default_subnet.default_az1.id}"
}