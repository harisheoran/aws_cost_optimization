# AWS Cloud Cost Optimization: Monitoring and Eliminating Stale Resources

Managing cloud costs is crucial for any organization leveraging AWS services. Imagine you have EC2 instances with attached EBS volumes containing important data. You take regular snapshots for backups, but when you delete the EC2 instances and their volumes, you might forget about those snapshots. This oversight can lead to unnecessary costs, especially in large organizations where tracking such stale resources is challenging. In this blog, we’ll explore an efficient AWS Lambda function designed to identify and eliminate these forgotten snapshots, helping you optimize your cloud expenditure.

## Real docs 
[Docs](https://harisheoran.xyz/projects/cloud_optimization/)

```
CGO_ENABLED=0 go build -o bootstrap main.go
zip lambda-handler.zip bootstrap
```

## Create Test resources
- ```cd test_resources```   
- ``` terraform init ```
- comment out snapshot module
- ``` terraform apply ```
- remove comment and create snapshots module resources by providing the volume ID in tfvars file.
- ``` terraform init```
- comment out ec2 module to make snapshot stale.


## Resources
- [Configuring the AWS SDK](https://aws.github.io/aws-sdk-go-v2/docs/configuring-sdk/#loading-aws-shared-configuration)

- [lambda function in Go](https://github.com/aws/aws-lambda-go)
