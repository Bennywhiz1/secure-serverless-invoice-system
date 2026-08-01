output "s3_bucket_name" {
  description = "Name of the S3 bucket used for invoice uploads"
  value       = aws_s3_bucket.invoice_bucket.id
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table storing invoice metadata"
  value       = aws_dynamodb_table.invoice_metadata.name
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.invoice_processor.function_name
}

output "api_gateway_url" {
  description = "Invoice API endpoint"

  value = aws_apigatewayv2_stage.default.invoke_url
}