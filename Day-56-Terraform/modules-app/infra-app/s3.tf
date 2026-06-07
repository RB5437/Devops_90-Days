resource "aws_s3_bucket" "remote_s3_bucket" {
  bucket = "${var.env}-${var.bucket_name}"

  tags = {
    Name = "rbb-remote-s3-bucket-1"
    Environment = var.env
  }
}