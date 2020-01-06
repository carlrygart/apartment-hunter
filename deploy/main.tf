provider "aws" {
  region = "eu-north-1"
}

resource "aws_lambda_function" "apartment_hunter" {
  filename      = "../dist/apartment_hunter.zip"
  function_name = "apartment_hunter"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "src/index.handler"
  source_code_hash = filebase64sha256("../dist/apartment_hunter.zip")
  runtime = "nodejs8.10"
  depends_on    = [aws_iam_role_policy_attachment.lambda_logs]
}

resource "aws_iam_role" "iam_for_lambda" {
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
