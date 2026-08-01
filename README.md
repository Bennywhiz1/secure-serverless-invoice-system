# Secure Serverless Invoice System

This project implements a secure, serverless invoice upload workflow using AWS Lambda, API Gateway, Amazon S3, and Amazon DynamoDB. The solution accepts invoice metadata from a client, validates the request, generates a pre-signed S3 URL for uploading a PDF, and stores invoice metadata in DynamoDB.

## Overview

The system is designed for safe and scalable invoice handling without managing traditional servers. A client sends a request to an HTTP API endpoint, and the backend:

- validates the incoming payload,
- ensures the file name ends with `.pdf`,
- creates a unique invoice ID,
- generates a temporary pre-signed URL for uploading the file to S3,
- stores metadata in DynamoDB for tracking.

## Architecture

The project uses the following AWS services:

- API Gateway: exposes the `POST /invoice` endpoint
- AWS Lambda: processes the upload request and returns a signed S3 URL
- Amazon S3: stores uploaded PDF invoices privately and securely
- Amazon DynamoDB: stores invoice metadata such as invoice ID, customer name, S3 key, and status

## Features

- Secure private S3 bucket configuration
- Server-side encryption enabled for uploaded objects
- Public access blocked on the S3 bucket
- Versioning enabled on the storage bucket
- Pre-signed URL generation for temporary upload access
- Simple API-based workflow for invoice submission

## Project Structure

- `lambda/lambda_function.py`: Lambda function implementation
- `lambda/requirements.txt`: Python dependencies
- `terraform/`: Infrastructure as Code for AWS resources
  - `apigateway.tf`
  - `dynamodb.tf`
  - `iam.tf`
  - `lambda.tf`
  - `s3.tf`
  - `variables.tf`
  - `outputs.tf`

## Prerequisites

Before deploying this project, make sure you have:

- An AWS account
- AWS CLI configured with valid credentials
- Terraform installed (`>= 1.6`)
- Python 3.12

## Deployment

1. Navigate to the Terraform directory:

   ```bash
   cd terraform
   ```

2. Initialize Terraform:

   ```bash
   terraform init
   ```

3. Review and apply the infrastructure:

   ```bash
   terraform apply -var-file=terraform.tfvars
   ```

4. Note the output values, especially the API Gateway URL.

If you change the Lambda code, package it before applying changes:

```bash
cd lambda
zip -r invoice_processor.zip lambda_function.py
```

## API Usage

Send a request to the deployed API endpoint:

```bash
curl -X POST "<api_gateway_url>/invoice" \
  -H "Content-Type: application/json" \
  -d '{"customer_name":"Acme Corp","file_name":"invoice.pdf"}'
```

Example successful response:

```json
{
  "invoice_id": "<uuid>",
  "upload_url": "<pre-signed-url>",
  "s3_key": "invoices/<uuid>-invoice.pdf"
}
```

Use the returned `upload_url` to upload the PDF directly to S3 with a `PUT` request.

## Cleanup

To remove all deployed resources:

```bash
cd terraform
terraform destroy -var-file=terraform.tfvars
```

## Notes

- Only PDF files are accepted by the API.
- The generated upload URL is temporary and expires after 300 seconds.
- The S3 bucket name is defined in `terraform/terraform.tfvars`.
