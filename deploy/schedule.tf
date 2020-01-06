resource "aws_cloudwatch_event_rule" "every_ten_minutes" {
  name = "every-ten-minutes"
  description = "Fires every ten minutes"
  schedule_expression = "rate(10 minutes)"
}

resource "aws_cloudwatch_event_target" "run_hunter_schedule" {
  rule = aws_cloudwatch_event_rule.every_ten_minutes.name
  arn = aws_lambda_function.apartment_hunter.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_apartment_hunter" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.apartment_hunter.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.every_ten_minutes.arn
}
