resource "aws_dynamodb_table" "emailed_apartments" {
  name           = "emailed_apartments"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "AnnonsId"

  attribute {
    name = "AnnonsId"
    type = "N"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }
}

resource "aws_iam_policy" "emailed_apartments_policy" {
  name = "emailed_apartments_policy"
  description = "IAM policy for dynamodb"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:Query"
      ],
      "Resource": "arn:aws:dynamodb:*:*:table/emailed_apartments",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "emailed_apartments_policy_attachment" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.emailed_apartments_policy.arn
}
