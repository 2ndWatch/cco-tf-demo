variable "domain_name" {
  type        = string
  description = "Atlantis domain name"
  default     = "aws.laiello.com"
}

variable "certificate_arn" {
  type        = string
  description = "ACM certificate for Atlantis"
  default     = "arn:aws:acm:us-east-1:966064235577:certificate/a7fc1081-6709-4469-b605-e5147fabba46"
}

variable "github_user_token" {
  description = "Github personal token"
  type        = string
  sensitive   = true
}

variable "github_webhook_secret" {
  description = "Github personal token"
  type        = string
  sensitive   = true
}
