output "ecr_repository_url" {
  value = module.ecr.ecr_repository_url
  description = "ECR URL for the Docker Image"
}