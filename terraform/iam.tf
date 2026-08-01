resource "aws_iam_role" "lambda_execution_role" {
  name = "invoice-processor-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Project     = "Secure Serverless Invoice System"
    Environment = "Development"
  }
}


data "aws_iam_policy_document" "lambda_policy" {

  statement {
    sid    = "AllowS3Upload"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetBucketLocation"
    ]

     resources = [
    "${aws_s3_bucket.invoice_bucket.arn}/*",
    aws_s3_bucket.invoice_bucket.arn
  ]
  }

  statement {
    sid    = "AllowDynamoDBWrite"
    effect = "Allow"

    actions = [
      "dynamodb:PutItem"
    ]

    resources = [
      aws_dynamodb_table.invoice_metadata.arn
    ]
  }


  statement {
    sid    = "AllowCloudWatchLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
  "arn:aws:logs:${var.aws_region}:*:log-group:/aws/lambda/invoice-processor*"
]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "invoice-processor-policy"
  description = "IAM policy for the Invoice Processor Lambda"

  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}