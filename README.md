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