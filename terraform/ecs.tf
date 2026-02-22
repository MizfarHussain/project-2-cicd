################################
# ECR Repository
################################

resource "aws_ecr_repository" "webapp" {
  name = var.ecr_repository

  image_scanning_configuration {
    scan_on_push = true
  }
}

################################
# ECS Cluster
################################

resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

################################
# CloudWatch Log Group
################################

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = "/ecs/${var.task_family}"
}

################################
# ECS Task Definition
################################

resource "aws_ecs_task_definition" "task" {
  family                   = var.task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "webapp"
      image = "nginx:latest"

      portMappings = [{
        containerPort = 3001
        protocol      = "tcp"
      }]

      environment = [{
        name  = "ENVIRONMENT"
        value = "production"
      }]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

################################
# ECS Service
################################

resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.webapp_sg.id]
    assign_public_ip = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.ecs_execution_attach
  ]
}