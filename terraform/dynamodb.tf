resource "aws_dynamodb_table" "invoice_metadata" {

  name         = "invoice-metadata"

  billing_mode = "PAY_PER_REQUEST"

  hash_key = "InvoiceID"

  attribute {
    name = "InvoiceID"
    type = "S"
  }

  tags = {
    Name        = "Invoice Metadata"
    Project     = "Secure Serverless Invoice System"
    Environment = "Development"
  }
}