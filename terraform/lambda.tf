resource "aws_lambda_function" "invoice_processor" {

  function_name = "invoice-processor"

  role = aws_iam_role.lambda_execution_role.arn

  runtime = "python3.12"
  handler = "lambda_function.lambda_handler"

  filename         = "../lambda/invoice_processor.zip"
  source_code_hash = filebase64sha256("../lambda/invoice_processor.zip")

  timeout = 30
  memory_size = 256

  environment {
    variables = {
      TABLE_NAME  = aws_dynamodb_table.invoice_metadata.name
      BUCKET_NAME = aws_s3_bucket.invoice_bucket.bucket
    }
  }

  tags = {
    Project     = "Secure Serverless Invoice System"
    Environment = "Development"
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy_attachment
  ]
}