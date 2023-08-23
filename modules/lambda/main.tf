
resource "aws_iam_role" "lambda-role" {
  name        = "${var.lambda_function_name}-role"
  description = "${var.lambda_function_name}-permissions"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["lambda.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.lambda_folder
  output_path = var.lambda_zip_filename
}


resource "aws_lambda_function" "lambda_function" {

  filename         = data.archive_file.lambda_zip.output_path
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda-role.arn
  handler          = var.handler
  runtime          = var.runtime
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  memory_size      = var.memory_size
  timeout          = var.timeout
}