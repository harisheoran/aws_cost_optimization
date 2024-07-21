resource "aws_iam_policy" "cost_optimization_lambda_policy" {
  name = "cost_optimization_policy"
  description = "Policy for lambda to access ec2"
  policy = jsonencode(
    {
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": [
				"ec2:DeleteSnapshot",
				"ec2:DescribeVolumes",
				"ec2:DescribeSnapshots"
			],
			"Resource": "*"
		}
	]
}
  )
}

resource "aws_iam_role" "cost_optimization_lambda_role" {
    name = "cost_optimization_lambda_role"
    assume_role_policy = jsonencode(
        {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
    )
  
}

resource "aws_iam_role_policy_attachment" "cost_optimization_lambda_policy_attachment" {
  role = aws_iam_role.cost_optimization_lambda_role.name
  policy_arn = aws_iam_policy.cost_optimization_lambda_policy.arn
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "/home/harisheoran/Personal/projects/aws_cost_optimization/bootstrap"
  output_path = "/home/harisheoran/Personal/projects/aws_cost_optimization/lambda-handler.zip"
}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "/home/harisheoran/Personal/projects/aws_cost_optimization/lambda-handler.zip"
  function_name = "cost_optimization_lambda"
  role          = aws_iam_role.cost_optimization_lambda_role.arn
  handler       = "index.test"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "provided.al2023"
}