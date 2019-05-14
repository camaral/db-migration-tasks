# DB Migrations using Liquibase and Cloud functions

[![CircleCI](https://circleci.com/gh/camaral/function-db-migration.svg?style=svg)](https://circleci.com/gh/camaral/function-db-migration)

## Trying it out
I made an effort to keep the system under the free tier, but I give no guarantees.

- Build the project by executing `./gradlew build`.
- Create a user on AWS that contains the rights described on `terraform/aws/main_tf_policy.json`. Change the `aws:SourceIp` to your own ip.
- Add the credentials to your environment (e.g. by adding it at ~/.aws/credentials) with profile `db_deployment`.
- Deploy the system to AWS. Considering that the command `terraform` is available on your classpath, you could execute the following. 
```
cd terraform/aws/
terraform init
terraform apply
```
- Invoke the function, either using the aws console or the awscli.
```
aws lambda invoke --region=us-east-1 --function-name=db_deployment --profile dbmigration output.txt
cat output.txt
```
- If you invoked it using the console, you will see the logs right away. If you invoked it using awscli, go to CloudWatch Log page to see the logs. 
- Once you are done with testing, you can destroy the system with `terraform destroy`.

## Troubleshooting
Java applications are not very economic with memory and also may take some time to start up.
If you are getting timeouts when invoking the lambda function, first check Cloudwatch logs, then try to increase
the parameter `timeout` and `memory_size` on`terraform/aws/main.tf`.
