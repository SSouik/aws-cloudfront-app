# S3 bucket is declared here since the cloudfront origin identity needs to be added
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = var.s3_bucket_id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "1",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
          },
          "Action" : "s3:GetObject",
          "Resource" : "arn:aws:s3:::${var.s3_bucket}/*"
        }
      ]
  })
}
