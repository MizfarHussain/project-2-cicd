output "AWS_ACCESS_KEY_ID" {
  value = aws_iam_access_key.github_key.id
}

output "AWS_SECRET_ACCESS_KEY" {
  value     = aws_iam_access_key.github_key.secret
  sensitive = true
}

output "ECR_REPOSITORY" {
  value = var.ecr_repository
}

output "AWS_REGION" {
  value = var.aws_region
}

output "ECS_CLUSTER" {
  value = aws_ecs_cluster.cluster.name
}

output "ECS_SERVICE" {
  value = aws_ecs_service.service.name
}

output "ECS_TASK_DEFINITION" {
  value = aws_ecs_task_definition.task.family
}