###########################################################################
# IAM for ECS
###########################################################################
resource "aws_iam_role" "ecs_execution" {
  name = "${var.env}-${var.app_name}-ecs-execution"
  assume_role_policy = jsonencode(
    {
      Version = "2008-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ecs-tasks.amazonaws.com"
          }
          Sid = ""
        },
      ]
    }
  )
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]
}


###########################################################################
# IAM for Step Functions
###########################################################################
resource "aws_iam_role" "sfn" {
  name = "${var.env}-${var.app_name}-sfn"
  assume_role_policy = jsonencode(
    {
      Version = "2008-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "states.amazonaws.com"
          }
          Sid = ""
        }
      ]
    }
  )
}

resource "aws_iam_policy" "sfn" {
  name = "${var.env}-${var.app_name}-sfn-role-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "WriteLogStreamsAndGroups"
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
          "logs:PutMetricFilter",
          "logs:PutRetentionPolicy"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Sid    = "ExecuteEcsTaks"
        Effect = "Allow"
        Action = [
          "ecs:*",
          "iam:PassRole"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "events:PutTargets",
          "events:PutRule",
          "events:DescribeRule",
          "states:*",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sfn-role-policy-attach" {
  role       = aws_iam_role.sfn.name
  policy_arn = aws_iam_policy.sfn.arn
}
