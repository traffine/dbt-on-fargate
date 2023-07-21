data "aws_ecr_repository" "dbt" {
  name = "${var.env}-${var.app_name}-dbt"
}
