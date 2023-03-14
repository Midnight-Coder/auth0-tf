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
  default     = "https://provider.development.headlamp.com/auth/login"
}

variable "azul_callbacks" {
  description = "Allowed Callback URLs"
  type        = list(string)
  default     = ["https://localhost:6040/auth/landing-pad", "http://localhost:6040/auth/landing-pad"]
}

variable "azul_logouts" {
  description = "Allowed Logout URLs"
  type        = list(string)
  default     = ["https://localhost:6040/auth/login", "http://localhost:6040/auth/login"]
}

variable "azul_web_origins" {
  description = "Allowed Web Origins"
  type        = list(string)
  default     = ["https://localhost:6040", "http://localhost:6040"]
}

variable "azul_logo_uri" {
  description = "Logo URI"
  type        = string
  default     = "https://lh3.googleusercontent.com/u/0/drive-viewer/AAOQEOSQPB5R_VgjWQa4lQrsI-_oLmutRxAnPuVx6qPVhsSd8Q7KiVjsf2yd2qChKezz_07Aw0g27rivDyclwgxXf7f1NbX5mw=w2560-h762"

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

variable "uno_callbacks" {
  description = "Allowed Callback URLs"
  type        = list(string)
  default = [
    "org.reactjs.native.example.uno://dev-datakeep-io.us.auth0.com/ios/org.reactjs.native.example.uno/callback",
    "com.uno://dev-datakeep-io.us.auth0.com/android/com.uno/callback"
  ]
}

variable "uno_logouts" {
  description = "Allowed Logout URLs"
  type        = list(string)
  default = [
    "org.reactjs.native.example.uno://dev-datakeep-io.us.auth0.com/ios/org.reactjs.native.example.uno/callback",
    "com.uno://dev-datakeep-io.us.auth0.com/android/com.uno/callback"
  ]
}

variable "uno_web_origins" {
  description = "Allowed Web Origins"
  type        = list(string)
  default = [
    "org.reactjs.native.example.uno://dev-datakeep-io.us.auth0.com/ios/org.reactjs.native.example.uno/callback",
    "com.uno://dev-datakeep-io.us.auth0.com/android/com.uno/callback"
  ]
}

variable "uno_logo_uri" {
  description = "Logo URI"
  type        = string
  default     = "https://lh3.googleusercontent.com/u/0/drive-viewer/AAOQEOSQPB5R_VgjWQa4lQrsI-_oLmutRxAnPuVx6qPVhsSd8Q7KiVjsf2yd2qChKezz_07Aw0g27rivDyclwgxXf7f1NbX5mw=w2560-h762"

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
variable "senet_web_token_lifetime" {
  description = "Senet Web Token Lifetime"
  type        = number
  default     = 7200
}
