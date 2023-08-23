resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "${var.project}-state-machine"
  role_arn = var.sf_exec_role_arn

  definition = <<-EOF
  {
  "Comment": "An AWS Step Function State Machine to train, build and deploy an Amazon SageMaker model endpoint",
  "StartAt": "Configuration Lambda",
  "States": {
    "Configuration Lambda": {
      "Type": "Task",
      "Resource": "${var.lambda_function_arn}",
      "Parameters": {
        "PrefixName": "${var.project}",
        "input_training_path": "$.input_training_path"
        },
      "Next": "Create Training Job",
      "ResultPath": "$.training_job_name"
      },
    "Create Training Job": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sagemaker:createTrainingJob.sync",
      "Parameters": {
        "TrainingJobName.$": "$.training_job_name",
        "ResourceConfig": {
          "InstanceCount": 1,
          "InstanceType": "${var.training_instance_type}",
          "VolumeSizeInGB": ${var.volume_size_sagemaker}
        },
        "HyperParameters": {
          "test": "test"
        },
        "AlgorithmSpecification": {
          "TrainingImage": "${var.ecr_repository_url}",
          "TrainingInputMode": "File"
        },
        "OutputDataConfig": {
          "S3OutputPath": "s3://${var.bucket_output_models}"
        },
        "StoppingCondition": {
          "MaxRuntimeInSeconds": 86400
        },
        "RoleArn": "${var.sagemaker_exec_role_arn}",
        "InputDataConfig": [
        {
          "ChannelName": "training",
          "ContentType": "text/csv",
          "DataSource": {
            "S3DataSource": {
              "S3DataType": "S3Prefix",
              "S3Uri": "s3://${var.bucket_training_data}",
              "S3DataDistributionType": "FullyReplicated"
            }
          }
        }
        ]
      },
      "Next": "Create Model"
    },
    "Create Model": {
      "Parameters": {
        "PrimaryContainer": {
          "Image": "${var.ecr_repository_url}",
          "Environment": {},
          "ModelDataUrl.$": "$.ModelArtifacts.S3ModelArtifacts"
        },
        "ExecutionRoleArn": "${var.sagemaker_exec_role_arn}",
        "ModelName.$": "$.TrainingJobName"
      },
      "Resource": "arn:aws:states:::sagemaker:createModel",
      "Type": "Task",
      "ResultPath":"$.taskresult",
      "Next": "Create Endpoint Config"
    },
    "Create Endpoint Config": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sagemaker:createEndpointConfig",
      "Parameters":{
        "EndpointConfigName.$": "$.TrainingJobName",
        "ProductionVariants": [
        {
          "InitialInstanceCount": 1,
          "InstanceType": "${var.inference_instance_type}",
          "ModelName.$": "$.TrainingJobName",
          "VariantName": "AllTraffic"
        }
        ]
      },
      "ResultPath":"$.taskresult",
      "Next":"Create Endpoint"
    },
    "Create Endpoint":{
      "Type":"Task",
      "Resource":"arn:aws:states:::sagemaker:createEndpoint",
      "Parameters":{
        "EndpointConfigName.$": "$.TrainingJobName",
        "EndpointName.$": "$.TrainingJobName"
      },
      "End": true
      }
    }
  }
  EOF
}
