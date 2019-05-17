provider "aws" {
  region = "us-east-1"
  profile = "dbmigration"
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-1a"
}

resource "aws_s3_bucket" "db_deployment" {
  bucket = "wd-iss-db-deployment"
  acl = "private"
}

resource "aws_s3_bucket_object" "object" {
  bucket = "${aws_s3_bucket.db_deployment.bucket}"
  key = "function-db-migration.jar"
  source = "../../build/libs/function-db-migration-0.0.1-SNAPSHOT.jar"
  etag = "${filemd5("../../build/libs/function-db-migration-0.0.1-SNAPSHOT.jar")}"
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
//    command = <<EOF
//aws ecs run-task --cluster ${aws_ecs_cluster.db_deployment.arn} --task-definition ${aws_ecs_task_definition.db_deployment.arn} \
//    --network-configuration 'awsvpcConfiguration={subnets=[${aws_default_subnet.default_az1.id}],assignPublicIp=ENABLED}' \
//    --launch-type=FARGATE --profile dbmigration --region us-east-1
//EOF
//  }
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