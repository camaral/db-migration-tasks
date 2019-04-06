provider "aws" {
  region  = "us-east-1"
  profile = "dbmigration"
}

//resource "aws_instance" "h2_database" {
//  ami           = "ami-2757f631"
//  instance_type = "t2.micro"
//}

resource "aws_iam_role" "iam_for_db_deployment" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "db_deployment" {
  filename         = "../build/distributions/liquibase-function-db-migration-0.0.1-SNAPSHOT.zip"
  function_name    = "db_deployment"
  role             = "${aws_iam_role.iam_for_db_deployment.arn}"
  handler          = "exports.test"
  source_code_hash = "${filebase64sha256("../build/distributions/liquibase-function-db-migration-0.0.1-SNAPSHOT.zip")}"
  runtime          = "java8"
}
