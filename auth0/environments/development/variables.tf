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

# Emails
variable "sengrid_key" {
  description = "Sendgrid API Key"
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
  default     = 36000
}

variable "gogo_token_lifetime" {
  description = "Absolute Token Lifetime"
  type        = number
  default     = 86400
}

variable "gogo_idle_token_lifetime" {
  description = "Idle Token Lifetime"
  type        = number
  default     = 36000
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

# Scopes
variable "auth0_actions_scopes" {
  description = "reading perms for auth0 actions"
  type        = list(string)
  default = [
    "read:organization_connections",
    "read:organization_invitations",
    "read:organization_member_roles",
    "read:organization_members",
    "read:organizations_summary",
    "read:organizations",
    "read:role_members",
    "read:roles",
    "read:user_custom_blocks",
    "read:users_app_metadata", "update:users_app_metadata",
    "read:users", "update:users", 
  ]
}

variable "management_api_scopes" {
  description = "perms for management api"
  type        = list(string)
  default = [
    "read:users", "delete:users", "update:users",
    "read:users_app_metadata", "update:users_app_metadata", "create:users_app_metadata",
    "read:clients",
    "read:connections",
    "read:roles", "update:roles",
    "read:role_members", "create:role_members", "delete:role_members",
    "read:organizations", "create:organizations", "update:organizations",
    "read:organization_members", "create:organization_members", "delete:organization_members",
    "read:organization_connections", "create:organization_connections",
    "read:organization_member_roles", "create:organization_member_roles", "delete:organization_member_roles",
    "create:organization_invitations", "read:organization_invitations"
  ]
}

# Auth0 Actions
variable "allowed_domains_allowlist" {
  type    = list(string)
  default = ["@gmail.com", "@superset.com", "@supercmo.ai", "@velotio.com"]
}
variable "allowed_emails_allowlist" {
  type    = list(string)
  default = []
}

variable "allowed_clients_allowlist" {
  description = "Applications that rely on SuperCMO SSO"
  type    = list(string)
  default = []
}
