### Provider Config
variable "auth0_domain" {
  description = "Auth0 Application Domain Endpoint"
  type        = string
}
variable "auth0_client_id" {
  description = "Auth0 Application Client ID"
  type        = string
}
variable "auth0_client_secret" {
  description = "Auth0 Application Client Secret"
  type        = string
}

variable "management_api_identifier" {
  description = "Management API Identifier"
  type        = string
}

variable "management_api_id" {
  description = "Management API Id"
  type        = string
}

variable "domain" {
  description = "Web Domain Address (without trailing slash. e.g. https://app.supercmo.com)"
  type        = string
}

# Branding
variable "logo_uri" {
  description = "Logo URI"
  type        = string
}

variable "primary_color" {
  description = "Primary Brand Color"
  type        = string
}

# Webapp
variable "gogo_id_token_expiration" {
  description = "Id Token Expiration Time"
  type        = number
  default     = 86400
}

variable "gogo_token_lifetime" {
  description = "Absolute Token Lifetime"
  type        = number
  default     = 86400
}

variable "gogo_idle_token_lifetime" {
  description = "Idle Token Lifetime"
  type        = number
  default     = 86400
}

# API-Gateway
variable "mogambo_token_lifetime" {
  description = "Mogambo Token Lifetime"
  type        = number
  default     = 86400
}
variable "mogambo_web_token_lifetime" {
  description = "mogambo Web Token Lifetime"
  type        = number
  default     = 86400
}
