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

variable "domain" {
  description = "Web Domain Address (without trailing slash. e.g. https://provider.demo.headlamp.com)"
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

variable "email_from" {
  description = "Email address to use as the sender"
  type        = string
}

variable "sendgrid_key" {
  description = "API Key For Sendgrid"
  type        = string
}

# Azul
variable "azul_id_token_expiration" {
  description = "Id Token Expiration Time"
  type        = number
  default     = 1800
}

variable "azul_token_lifetime" {
  description = "Absolute Token Lifetime"
  type        = number
  default     = 28800
}

variable "azul_idle_token_lifetime" {
  description = "Idle Token Lifetime"
  type        = number
  default     = 5400
}

variable "azul_login_uri" {
  description = "Custom Login URI"
  type        = string
  default     = join("", var.domain, "/auth/login")
}

variable "azul_callbacks" {
  description = "Allowed Callback URLs"
  type        = list(string)
  default     = [join("", var.domain, "/auth/landing-pad")]
}

variable "azul_logouts" {
  description = "Allowed Logout URLs"
  type        = list(string)
  default     = [join("", var.domain, "/auth/logout")]
}

variable "azul_web_origins" {
  description = "Allowed Web Origins"
  type        = list(string)
  default     = [var.domain]
}

# Uno
variable "uno_id_token_expiration" {
  description = "Id Token Expiration Time"
  type        = number
  default     = 36000
}

variable "uno_token_lifetime" {
  description = "Absolute Token Lifetime"
  type        = number
  default     = 2592000
}

variable "uno_idle_token_lifetime" {
  description = "Idle Token Lifetime"
  type        = number
  default     = 1296000
}

variable "uno_web_origins" {
  description = "Allowed Web Origins"
  type        = list(string)
  default = [
    join("", "org.reactjs.native.example.uno://", var.auth0_domain, "/ios/org.reactjs.native.example.uno/callback"),
    join("", "com.uno://", var.auth0_domain, "/android/com.uno/callback"),
  ]
}

# Jenga
variable "jenga_api_identifier" {
  description = "Jenga Api Identifier"
  type        = string
  default     = "https://localhost:5050"
}

variable "jenga_token_lifetime" {
  description = "Jenga Token Lifetime"
  type        = number
  default     = 86400
}
variable "jenga_web_token_lifetime" {
  description = "Jenga Web Token Lifetime"
  type        = number
  default     = 7200
}

# Senet
variable "senet_api_identifier" {
  description = "Senet Api Identifier"
  type        = string
  default     = "https://localhost:5080"
}

variable "senet_token_lifetime" {
  description = "Senet Token Lifetime"
  type        = number
  default     = 86400
}

# Codenames: User Management API
variable "codenames_api_identifier" {
  description = "Codenames Api Identifier"
  type        = string
  default     = "https://localhost:5060"
}

variable "codenames_scopes" {
  description = "Codenames Permissions"
  type        = list(string)
  default = [
    "read:clients",
    "read:connections",
    "read:roles",
    "read:users", "create:users", "delete:users",
    "read:organizations", "create:organizations", "read:organization_members", "create:organization_members",
    "read:organization_connections", "create:organization_connections", "update:organization_connections",
    "read:organization_invitations", "create:organization_invitations",
    "read:organization_member_roles", "create:organization_member_roles"
  ]
}
