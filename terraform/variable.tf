variable "aws_access_key" {
  description = "AWS Access Key"
  default     = "AKIAFAKEACCESSKEY" # **Vulnerability: Hardcoded AWS Key** (Checkov: CKV_SECRET_2)
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  default     = "fakeSecretKey123" # **Vulnerability: Hardcoded Secret** (Checkov: CKV_SECRET_2)
}

variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}