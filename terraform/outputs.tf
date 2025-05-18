output "ecs_cluster_name" {
  value = aws_ecs_cluster.cloudtasks_cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.cloudtasks_service.name
}
