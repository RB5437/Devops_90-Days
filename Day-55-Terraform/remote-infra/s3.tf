resource "aws_s3_bucket" "remote_s3_bucket" {
  bucket = "rbb-remote-s3-bucket-1"

  tags = {
    Name = "rbb-remote-s3-bucket-1"
  }
}