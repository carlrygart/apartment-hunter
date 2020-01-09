provider "aws" {
  region = "eu-north-1"
}

resource "aws_lambda_function" "apartment_hunter" {
  filename      = "../dist/apartment_hunter.zip"
  function_name = "apartment_hunter"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"
  source_code_hash = filebase64sha256("../dist/apartment_hunter.zip")
  runtime = "nodejs8.10"
  depends_on    = [aws_iam_role_policy_attachment.lambda_logs]
}
resource "aws_cloudwatch_event_rule" "every_ten_minutes" {
  name = "every-ten-minutes"
  description = "Fires every ten minutes"
  schedule_expression = "rate(10 minutes)"
}

resource "aws_cloudwatch_event_target" "run_hunter_schedule" {
  rule = aws_cloudwatch_event_rule.every_ten_minutes.name
  arn = aws_lambda_function.apartment_hunter.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.apartment_hunter.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.every_ten_minutes.arn
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
        "logs:CreateLogGroup",
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
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
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
