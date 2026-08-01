import json
import os
import uuid
import boto3

s3 = boto3.client("s3")
dynamodb = boto3.resource("dynamodb")

TABLE_NAME = os.environ["TABLE_NAME"]
BUCKET_NAME = os.environ["BUCKET_NAME"]

table = dynamodb.Table(TABLE_NAME)


def lambda_handler(event, context):
    try:
        body = json.loads(event.get("body", "{}"))

        customer_name = body.get("customer_name")
        file_name = body.get("file_name")

        if not customer_name or not file_name:
            return {
                "statusCode": 400,
                "body": json.dumps({
                    "message": "customer_name and file_name are required."
                })
            }

        if not file_name.lower().endswith(".pdf"):
            return {
                "statusCode": 400,
                "body": json.dumps({
                    "message": "Only PDF files are allowed."
                })
            }

        invoice_id = str(uuid.uuid4())

        object_key = f"invoices/{invoice_id}-{file_name}"

        upload_url = s3.generate_presigned_url(
            ClientMethod="put_object",
            Params={
                "Bucket": BUCKET_NAME,
                "Key": object_key,
                "ContentType": "application/pdf"
            },
            ExpiresIn=300
        )

        table.put_item(
            Item={
                "InvoiceID": invoice_id,
                "CustomerName": customer_name,
                "S3Key": object_key,
                "Status": "PENDING_UPLOAD"
            }
        )

        return {
            "statusCode": 200,
            "body": json.dumps({
                "invoice_id": invoice_id,
                "upload_url": upload_url,
                "s3_key": object_key
            })
        }

    except Exception as e:
        print(f"Error: {str(e)}")

        return {
            "statusCode": 500,
            "body": json.dumps({
                "message": "Internal Server Error"
            })
        }