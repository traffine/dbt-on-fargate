resource "aws_sfn_state_machine" "elt" {
  name     = "${var.env}-${var.app_name}"
  role_arn = aws_iam_role.sfn.arn

  definition = <<EOF
  {
    "StartAt": "RunDbtTask",
    "States": {
      "RunDbtTask": {
        "Type": "Task",
        "Resource": "arn:aws:states:::ecs:runTask.sync",
        "Parameters": {
          "Cluster": "${aws_ecs_cluster.elt.arn}",
          "TaskDefinition": "${aws_ecs_task_definition.dbt.arn}",
          "LaunchType": "FARGATE",
          "NetworkConfiguration": {
            "AwsvpcConfiguration": {
              "Subnets": ${jsonencode(tolist([for s in aws_subnet.public : s.id]))},
              "SecurityGroups": [
                "${aws_security_group.dbt_security_group.id}"
              ],
              "AssignPublicIp": "ENABLED"
            }
          }
        },
        "End": true
      }
    }
  }
  EOF
}
