################################
# ECS Task Execution Role
################################

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecsTaskExecutionRole-${var.cluster_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_attach" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

################################
# GitHub Actions IAM User
################################

resource "aws_iam_user" "github_user" {
  name = var.github_user_name
}

resource "aws_iam_user_policy_attachment" "ecs_access" {
  user       = aws_iam_user.github_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_user_policy_attachment" "ecr_access" {
  user       = aws_iam_user.github_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_access_key" "github_key" {
  user = aws_iam_user.github_user.name
}