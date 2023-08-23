output sagemaker_exec_role_arn {
    value = aws_iam_role.sagemaker_exec_role.arn
}

output sf_exec_role_arn {
    value = aws_iam_role.sf_exec_role.arn
}