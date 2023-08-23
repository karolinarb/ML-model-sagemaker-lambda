variable region {
  type    = string
  default = "eu-west-1"
}

variable project {
  type = string
  description = "Name of the project"
}

variable bucket_training_data_arn {}
variable bucket_output_models_arn {}
variable lambda_function_arn {}