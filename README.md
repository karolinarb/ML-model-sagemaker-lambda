# Pipeline for ML model in Sagemaker 

1. Terraform apply:
   - Creates an ECR repo and builds and pushes Docker image. Creates IAM roles for step function and sagemaker.
   - Creates two S3 buckets: for input and output data.
   - Step Functions starts an AWS Lambda function, generating a unique job ID, which is then used when starting a SageMaker training job.
   - Step Functions also creates a model, endpoint configuration, and endpoint used for inference.
   - The SageMaker training job uses an algorithm from an ECR image.


![diagram](.//ML4359-architecture-diagram-1.png)


Source: 
- [Amazon Blog](https://aws.amazon.com/blogs/machine-learning/deploy-and-manage-machine-learning-pipelines-with-terraform-using-amazon-sagemaker/)
- [Github Repo](https://github.com/aws-samples/amazon-sagemaker-ml-pipeline-deploy-with-terraform)
