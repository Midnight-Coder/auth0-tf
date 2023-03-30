locals {
  azul_login_uri = join("", [var.domain, "/auth/login"])
  azul_callbacks = [join("", [var.domain, "/auth/landing-pad"])]
  azul_logouts = [
    join("", [var.domain, "/auth/logout"]),
    join("", [var.domain, "/auth/login"]),
  ]
}

locals {
  uno_web_origins = [
    join("", ["org.reactjs.native.example.uno://", var.auth0_domain, "/ios/org.reactjs.native.example.uno/callback"]),
    join("", ["com.uno://", var.auth0_domain, "/android/com.uno/callback"]),
  ]
}

locals {
  jenga_api_identifier = join("", [var.domain, "/api"])
}

locals {
  codenames_api_identifier = var.domain
}

locals {
  senet_api_identifier = join("", [var.domain, "/app-api"])
}

resource "auth0_client" "azul-provider-console" {
  name                       = "Headlamp Health"
  description                = "Headlamp Console For Providers"
  app_type                   = "spa"
  oidc_conformant            = true
  token_endpoint_auth_method = "none"
  initiate_login_uri         = local.azul_login_uri
  callbacks                  = local.azul_callbacks
  allowed_logout_urls        = local.azul_logouts
  web_origins                = [var.domain]
  custom_login_page_on       = false
  logo_uri                   = var.logo_uri
  is_first_party             = true
  grant_types = [
    "implicit",
    "password",
    "refresh_token",
    "authorization_code",
  ]

  organization_usage = "deny"

  refresh_token {
    expiration_type              = "expiring"
    rotation_type                = "rotating"
    infinite_idle_token_lifetime = false
    infinite_token_lifetime      = false
    leeway                       = 0
    token_lifetime               = var.azul_token_lifetime
    idle_token_lifetime          = var.azul_idle_token_lifetime

  }

  jwt_configuration {
    alg                 = "RS256"
    lifetime_in_seconds = var.azul_id_token_expiration
  }
}

resource "auth0_client" "uno-patient-mobile-app" {
  name                       = "Headlamp Health App"
  description                = "Headlamp App For Patients"
  app_type                   = "native"
  oidc_conformant            = true
  token_endpoint_auth_method = "none"
  web_origins                = local.uno_web_origins
  custom_login_page_on       = false
  logo_uri                   = var.logo_uri
  is_first_party             = true
  grant_types = [
    "implicit",
    "password",
    "refresh_token",
    "authorization_code",
  ]
  organization_usage = "deny"

  refresh_token {
    expiration_type              = "expiring"
    rotation_type                = "rotating"
    infinite_idle_token_lifetime = false
    infinite_token_lifetime      = false
    leeway                       = 0
    token_lifetime               = var.uno_token_lifetime
    idle_token_lifetime          = var.uno_idle_token_lifetime

  }

  jwt_configuration {
    alg                 = "RS256"
    lifetime_in_seconds = var.uno_id_token_expiration
  }

}

resource "auth0_client" "jenga-gateway" {
  name            = "Jenga API Gateway"
  description     = "API Gateway for Azul (Provider Webapp)"
  app_type        = "non_interactive"
  oidc_conformant = true
  is_first_party  = true
}

resource "auth0_resource_server" "jenga-resource-server" {
  name                                            = "Jenga Resource Server"
  identifier                                      = local.jenga_api_identifier
  skip_consent_for_verifiable_first_party_clients = true
  token_dialect                                   = "access_token_authz"
  enforce_policies                                = true
  token_lifetime                                  = var.jenga_token_lifetime
  token_lifetime_for_web                          = var.jenga_web_token_lifetime
}

resource "auth0_client" "senet-gateway" {
  name            = "Senet API Gateway"
  description     = "API Gateway for Uno (Patient Mobile App)"
  app_type        = "non_interactive"
  oidc_conformant = true
  is_first_party  = true
}

resource "auth0_client" "codenames-client" {
  name            = "Codenames Management Service"
  description     = "Codenames Management Service Auth0 Client"
  app_type        = "non_interactive"
  oidc_conformant = true

  grant_types = [
    "client_credentials",
  ]
}


resource "auth0_resource_server" "senet-resource-server" {
  name                                            = "Senet Resource Server"
  identifier                                      = local.senet_api_identifier
  skip_consent_for_verifiable_first_party_clients = true
  token_dialect                                   = "access_token_authz"
  enforce_policies                                = true
  token_lifetime                                  = var.senet_token_lifetime
}

resource "auth0_resource_server" "codenames-user-management" {
  name       = "Codenames Management Client"
  identifier = local.codenames_api_identifier

  dynamic "scopes" {
    for_each = var.codenames_scopes
    content {
      value = scopes.value
    }
  }
}
