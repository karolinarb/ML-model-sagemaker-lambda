terraform {
  required_version = ">= 0.13.5"
}

provider "aws" {
  region = var.region
}

locals {
  s3_bucket_input_training_path = "${var.project}-training-data-${data.aws_caller_identity.current.account_id}"
  s3_bucket_output_models_path = "${var.project}-output-models-${data.aws_caller_identity.current.account_id}"
  s3_object_training_data = "./data/iris.csv"
  input_training_path = "s3://${var.project}-training-data-${data.aws_caller_identity.current.account_id}"
  output_models_path = "s3://${var.project}-output-models-${data.aws_caller_identity.current.account_id}"
  lambda_function_name = "config-${var.project}"
  lambda_folder = "${var.handler_path}/"
  lambda_zip_filename = "${var.handler_path}.zip"
}

# Get Caller Identity Info
data "aws_caller_identity" "current" {}

module "ecr" {
    source = "./modules/ecr"
    project = var.project
}

module "iam" {
    source = "./modules/iam"
    project = var.project
    bucket_training_data_arn = module.s3.bucket_training_data_arn
    bucket_output_models_arn = module.s3.bucket_output_models_arn
    lambda_function_arn = module.lambda.lambda_function_arn
}

module "s3" {
    source = "./modules/s3"
    project = var.project
    s3_bucket_input_training_path = local.s3_bucket_input_training_path
    s3_object_training_data = local.s3_object_training_data
    s3_bucket_output_models_path = local.s3_bucket_output_models_path
}

module "lambda" {
    source = "./modules/lambda"
    project = var.project
    lambda_function_name = local.lambda_function_name
    handler_path = var.handler_path
    handler = var.handler
    lambda_folder = local.lambda_folder
    lambda_zip_filename = local.lambda_zip_filename
}

module "sfn" {
    source = "./modules/sfn"
    project = var.project
    training_instance_type = var.training_instance_type
    inference_instance_type = var.inference_instance_type
    volume_size_sagemaker = var.volume_size_sagemaker
    lambda_function_arn  = module.lambda.lambda_function_arn
    ecr_repository_url = module.ecr.ecr_repository_url
    bucket_output_models = module.s3.bucket_output_models
    sagemaker_exec_role_arn = module.iam.sagemaker_exec_role_arn
    bucket_training_data = module.s3.bucket_training_data
    sf_exec_role_arn = module.iam.sf_exec_role_arn

}