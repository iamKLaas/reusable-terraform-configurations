provider "aws" {
  region = var.aws_region
}

resource "aws_iot_thing" "iot_thing" {
  name = var.iot_thing_name
}

resource "aws_iot_certificate" "iot_thing_cert" {
  active = true
}

resource "aws_iot_thing_principal_attachment" "att" {
  principal = aws_iot_certificate.iot_thing_cert.arn
  thing     = aws_iot_thing.iot_thing.name
}

resource "aws_iot_policy_attachment" "policy_att" {
  policy = aws_iot_policy.iot_thing_policy.name
  target = aws_iot_certificate.iot_thing_cert.arn
}

resource "local_file" "iot_thing_cert_file" {
    content  = aws_iot_certificate.iot_thing_cert.certificate_pem
    filename = var.iot_thing_cert_file_name
}

resource "local_file" "iot_thing_cert_private_key_file" {
    content  = aws_iot_certificate.iot_thing_cert.private_key
    filename = var.iot_thing_cert_private_key_file_name
}

resource "aws_iot_policy" "iot_thing_policy" {
  name = var.iot_thing_policy_name
  policy = jsonencode(var.iot_thing_policy)
}

variable "aws_region" {
  type        = string
  description = "AWS Region where the resources shall be deployed"
  default     = "eu-central-1"
}

variable "aws_account_id" {
  type        = string
  description = "Account ID of your AWS account"
  sensitive = true
}

variable "iot_thing_name" {
  type = string
  description = "Name of the AWS IoT Thing"
}

variable "iot_thing_cert_file_name" {
  type = string
  description = "File name of the certificate of the AWS IoT Thing"
  default = "iot_thing_cert.pem"
}

variable "iot_thing_cert_private_key_file_name" {
  type = string
  description = "File name of the the private key of the AWS IoT Thing"
  default = "iot_thing_cert_private_key.pem"
}

variable "iot_thing_policy_name" {
  type = string
  description = "AWS IoT Policy name which will be used by the created AWS IoT Thing"
  default = "iot_thing_policy"
}

variable "iot_thing_policy" {
  type = object({
    Version = string,
    Statement = list(object({
      Effect = string,
      Action = list(string),
      Resource = list(string)
    }))
  })
  description = "AWS IoT Policy that will be attached to the certifacte used by the AWS IoT Thing"
}