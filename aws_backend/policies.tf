resource "aws_s3_bucket_policy" "terraform_bucket_policy" {
    bucket = aws_s3_bucket.terraform_state.id

    policy = jsonencode({
    "Version": "2012-10-17",
    "Id": "ExamplePolicy",
    "Statement": [
        {
            "Sid": "AllowSSLRequestsOnly",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "${aws_s3_bucket.terraform_state.arn}",
                "${aws_s3_bucket.terraform_state.arn}/*"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
})
}

resource "aws_s3_bucket_public_access_block" "terraform_block_public_access" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}