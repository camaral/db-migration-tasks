provider "aws" {
  region = "us-east-1"
  profile = "dbmigration"
}

resource "aws_ecs_cluster" "db_deployment" {
  name = "db-deployment-cluster"
}

resource "aws_ecs_task_definition" "db_deployment" {
  container_definitions = "${file("./db-migration-task-definition.json")}"
  family = "db-deployment-definition"
  cpu = "256"
  memory = "512"
  network_mode = "awsvpc"
  requires_compatibilities = [
    "FARGATE"
  ]
}

output "cluster_arn" {
  value = "${aws_ecs_cluster.db_deployment.arn}"
}

output "task_definition_arn" {
  value = "${aws_ecs_task_definition.db_deployment.arn}"
}