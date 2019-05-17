provider "aws" {
  region  = "us-east-1"
  profile = "dbmigration"
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${aws_lambda_function.db_deployment.function_name}"
  retention_in_days = 5
}

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

resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = "${aws_iam_role.iam_for_db_deployment.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}

resource "aws_lambda_function" "db_deployment" {
  filename         = "../../build/distributions/function-db-migration-0.0.1-SNAPSHOT.zip"
  function_name    = "db_deployment"
  role             = "${aws_iam_role.iam_for_db_deployment.arn}"
  handler          = "camaral.dbmigration.aws.DbMigration::run"
  source_code_hash = "${filebase64sha256("../../build/distributions/function-db-migration-0.0.1-SNAPSHOT.zip")}"
  runtime          = "java8"
  timeout          = 60
  memory_size      = 192
}
