###########################################################################
# ECS Cluster
###########################################################################
resource "aws_ecs_cluster" "elt" {
  name = "${var.env}-${var.app_name}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

###########################################################################
# ECS Task Definition
###########################################################################
resource "aws_ecs_task_definition" "dbt" {
  family                   = "${var.env}-${var.app_name}-dbt"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name      = "${var.env}-${var.app_name}-dbt"
      image     = "${data.aws_ecr_repository.dbt.repository_url}:latest",
      essential = true
      command   = ["dbt", "run", "--target", "prod", "--profiles-dir", "."]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = "ap-northeast-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
