variable "GOOGLE_CREDENTIALS" {
  description = "The Google Cloud credentials"
  type        = string
}

variable "project" {
  description = "Project where we are actually deploying resources"
  type        = string
}

variable "region" {
  description = "The region where resources should be created"
  type        = string
}

variable "user" {
  description = "User"
  type        = string
}

variable "public_key" {
  type    = string
}

variable "private_key" {
  type    = string
}

variable "MYSQL_USER" {
  type    = string
}

variable "MYSQL_PASSWORD" {
  type    = string
}

