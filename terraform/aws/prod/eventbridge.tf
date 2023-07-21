resource "aws_cloudwatch_event_rule" "dbt" {
  name                = "${var.env}-${var.app_name}-event-rule"
  description         = "This is event rule for ${var.env}-${var.app_name}."
  schedule_expression = "cron(0 1 * * ? *)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_target" "dbt" {
  rule     = aws_cloudwatch_event_rule.dbt.name
  arn      = aws_sfn_state_machine.elt.arn
  role_arn = aws_iam_role.sfn.arn
}
