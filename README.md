# DB Migrations using Liquibase and Cloud functions

[![CircleCI](https://circleci.com/gh/camaral/liquibase-function-db-migration.svg?style=svg)](https://circleci.com/gh/camaral/liquibase-function-db-migration)

## Trying it out
I made an effort to keep the system under the free tier, but I give no guarantees.

- Create a user on AWS that contains the rights described on `terraform/main_tf_policy.json`. Change the `aws:SourceIp` to your own ip.
- Add the credentials to your environment (e.g. by adding it at ~/.aws/credentials) with profile `db_deployment`.
- Deploy the system to AWS. 
```
cd terraform
terraform init
terraform apply
```
- Invoke the function.
```aws lambda invoke --region=us-east-1 --function-name=db_deployment --profile dbmigration output.txt
cat output.txt
```

## Troubleshooting
Spring applications are not very economic with memory and also may take some time to start up.
If you are getting timeouts when invoking the lambda function, first check Cloudwatch logs, then try to increase
the parameter `timeout` and `memory_size` on`terraform/main.tf`.
