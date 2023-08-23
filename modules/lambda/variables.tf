variable project {}
variable lambda_function_name {
  type = string
  description = "Name of the lambda function creating a unique ID"
}
variable handler_path {
  type = string
  description = "Path of the lambda handler"
}

variable handler {
  type = string
  description = "Name of the lambda function handler"
}

variable "runtime" {
  type = string
  default = "python3.7"
}

variable "memory_size" {
  type = string
  description = "Memory Lambda in MB"
  default = "128"
}

variable "timeout" {
  type = string
  description = "Timeout Lambda in Seconds"
  default = "200"
}

variable lambda_folder {
  type = string
  description = "Folder for the lambda function"
}

variable lambda_zip_filename {
  type = string
  description = "The filename of the zip function from the lambda function"
}
