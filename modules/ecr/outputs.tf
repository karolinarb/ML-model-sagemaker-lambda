output "trigged_by" {
  value = null_resource.build_push_dkr_img.triggers
}

output "ecr_repository_url" {
    value = aws_ecr_repository.ecr_repo.repository_url
}

output "ecr_repository" {
    value = aws_ecr_repository.ecr_repo
}