# S3 bucket is declared here since the cloudfront origin identity needs to be added
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  for_each = var.s3_app_configs
  bucket   = aws_s3_bucket.app_bucket[each.key].id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "1",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : aws_cloudfront_origin_access_identity.s3_app_origin_access_identity[each.key].iam_arn
          },
          "Action" : "s3:GetObject",
          "Resource" : "arn:aws:s3:::${aws_s3_bucket.app_bucket[each.key].bucket}/*"
        }
      ]
  })
}
