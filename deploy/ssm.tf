resource "aws_iam_policy" "ssm" {
  name = "ssm"
  path = "/"
  description = "IAM policy for SSM"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ssm:GetParameter"
      ],
      "Resource": "arn:aws:ssm:*:*:parameter/*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_ssm" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.ssm.arn
}
