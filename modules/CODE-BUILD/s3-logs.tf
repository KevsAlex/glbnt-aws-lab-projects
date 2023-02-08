#--------------------------
# S3 BUCKET
#---------------------------

locals {

  json_policiy = {

    #--------------------------
    # Dev configs
    #---------------------------
    dev = jsonencode({
      Version : "2012-10-17",
      Statement : [
        {
          Sid : "DenyUnEncryptedObjectUploads",
          Effect : "Deny",
          Principal : "*",
          Action : "s3:PutObject",
          Resource : "${aws_s3_bucket.pipeline-log-bucket.arn}/*",
          Condition : {
            StringNotEquals : {
              "s3:x-amz-server-side-encryption" : "aws:kms"
            }
          }
        },
        {
          Sid : "DenyInsecureConnections",
          Effect : "Deny",
          Principal : "*",
          Action : "s3:*",
          Resource : "${aws_s3_bucket.pipeline-log-bucket.arn}/*",
          Condition : {
            Bool : {
              "aws:SecureTransport" : "false"
            }
          }
        }
      ]
    })

    #--------------------------
    # Configuracion de prod , se agregan políticas de kms que no tiene stage
    #---------------------------
    prod = jsonencode({
      Version : "2012-10-17",
      Statement : [
        {
          Sid : "DenyUnEncryptedObjectUploads",
          Effect : "Deny",
          Principal : "*",
          Action : "s3:PutObject",
          Resource : "${aws_s3_bucket.pipeline-log-bucket.bucket}/*",
          Condition : {
            StringNotEquals : {
              "s3:x-amz-server-side-encryption" : "aws:kms"
            }
          }
        },
        {
          Sid : "DenyInsecureConnections",
          Effect : "Deny",
          Principal : "*",
          Action : "s3:*",
          Resource : "${aws_s3_bucket.pipeline-log-bucket.bucket}/*",
          Condition : {
            Bool : {
              "aws:SecureTransport" : "false"
            }
          }
        },
        {
          Sid : "an id",
          Effect : "Allow",
          Principal : {
            "AWS" : "arn:aws:iam::${var.AWS_ACCOUNT_ID}:root"
          },
          Action : [
            "s3:Get*",
            "s3:Put*"
          ],
          //Resource: "arn:aws:s3:::codepipeline-us-east-1-590243117178/*"
          Resource : "${aws_s3_bucket.pipeline-log-bucket.arn}/*"
        },
        {
          Sid : "otherid",
          Effect : "Allow",
          Principal : {
            "AWS" : "arn:aws:iam::${var.AWS_ACCOUNT_ID}:root"
          },
          Action : "s3:ListBucket",
          //Resource: "arn:aws:s3:::codepipeline-us-east-1-590243117178"
          Resource : "${aws_s3_bucket.pipeline-log-bucket.arn}"
        }
      ]
    })
  }

}
resource "aws_s3_bucket" pipeline-log-bucket {
  bucket = "codepipeline-log-${var.AWS_ACCOUNT_ID}-${var.AWS_DEFAULT_REGION}-${var.environment}"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.pipeline-log-bucket.id
  policy = local.json_policiy[var.environment]

  depends_on = [aws_s3_bucket.pipeline-log-bucket]
}
