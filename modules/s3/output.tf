output bucket_output_models {
    value = aws_s3_bucket.bucket_output_models.bucket
}
output bucket_training_data {
    value = aws_s3_bucket.bucket_training_data.bucket
}

output bucket_output_models_arn {
    value = aws_s3_bucket.bucket_output_models.arn
}
output bucket_training_data_arn {
    value = aws_s3_bucket.bucket_training_data.arn
}
