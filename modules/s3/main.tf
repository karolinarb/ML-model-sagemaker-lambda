resource "aws_s3_bucket" "bucket_training_data" {
  bucket = var.s3_bucket_input_training_path
}

resource "aws_s3_bucket_ownership_controls" "bucket_training_data" {
  bucket = aws_s3_bucket.bucket_training_data.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket_training_data_acl" {
    depends_on = [aws_s3_bucket_ownership_controls.bucket_training_data]
  bucket = aws_s3_bucket.bucket_training_data.id
  acl    = "private"
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket_training_data.id
  key    = "iris.csv"
  source = var.s3_object_training_data
}

resource "aws_s3_bucket" "bucket_output_models" {
  bucket = var.s3_bucket_output_models_path
}

resource "aws_s3_bucket_ownership_controls" "bucket_output_models" {
  bucket = aws_s3_bucket.bucket_output_models.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket_output_models_acl" {
    depends_on = [aws_s3_bucket_ownership_controls.bucket_output_models] 
    bucket = aws_s3_bucket.bucket_output_models.id
    acl    = "private"
}
