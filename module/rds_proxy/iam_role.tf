resource "aws_iam_role" "iaac_aws_iam_role" {
  name = "test_role"
  assume_role_policy = "${file("../module/rds_proxy/role.tpl")}"

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_policy" "iaac_aws_iam_policy" {
  name = "aws-iam-policy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GetSecretValue",
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Effect": "Allow",
            "Resource": [
                "${aws_secretsmanager_secret.iaac_rds_credentials.arn}"
            ]
        },
        {
            "Sid": "DecryptSecretValue",
            "Action": [
                "kms:Decrypt"
            ],
            "Effect": "Allow",
            "Resource": [
                "${data.aws_kms_key.iaac_aws_kms_key.arn}"
            ],
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "secretsmanager.ap-south-1.amazonaws.com"
                }
            }
        }
    ]
})
}
resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = [aws_iam_role.iaac_aws_iam_role.name]
  policy_arn = aws_iam_policy.iaac_aws_iam_policy.arn
}