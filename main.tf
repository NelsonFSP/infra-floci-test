# ECR Repository
resource "aws_ecr_repository" "aws_ecr" {
    name = "local-ecr"
    image_tag_mutability = "MUTABLE" # represents the tag mutability for repository
}

# ECS Cluster
resource "aws_ecs_cluster" "aws_ecs_cluster" {
    name = "local-ecs-cluster"  
}

# Trust Policy
data "aws_iam_policy_document" "ecs_assume_role" {
    statement {
      actions = ["sts:AssumeRole"]

      principals {
        type      = "Service"
        identifiers =  ["ecs-tasks.amazonaws.com"]
      }
    }
}

# IAM Role
resource "aws_iam_role" "ecs_execution_role" {
    name = "ecs_role"
    assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json 
}

# ECS Task Definition
resource "aws_ecs_task_definition" "aws_ecs_task_definition" {
    family = "ecs_service"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = "256"
    memory = "512"
    execution_role_arn = aws_iam_role.ecs_execution_role.arn
    container_definitions = jsonencode([
        {
            name = "ecs-container"
            image = "${aws_ecr_repository.aws_ecr.repository_url}:latest"
            essential = true
            portMappings = [
                {
                    containerPort = 90
                    hostPort      = 80
                }
            ]
        }
    ])
}