locals {
  gogo_login_uri = join("", [var.domain, "/auth/login"])
  gogo_callbacks = [join("", [var.domain, "/auth/landing-pad"])]
  gogo_logouts = [
    join("", [var.domain, "/auth/logout"]),
    join("", [var.domain, "/auth/login"]),
  ]
}

resource "auth0_client" "gogo-frontend-console" {
  name                       = "SuperCMO"
  description                = "SuperCMO Frontend Console"
  app_type                   = "spa"
  oidc_conformant            = true
  token_endpoint_auth_method = "none"
  initiate_login_uri         = local.gogo_login_uri
  callbacks                  = local.gogo_callbacks
  allowed_logout_urls        = local.gogo_logouts
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
    token_lifetime               = var.gogo_token_lifetime
    idle_token_lifetime          = var.gogo_idle_token_lifetime

  }

  jwt_configuration {
    alg                 = "RS256"
    lifetime_in_seconds = var.gogo_id_token_expiration
  }
}

resource "auth0_client" "mogambo-gateway" {
  name            = "Mogambo API Gateway"
  description     = "Mogambo API Gateway"
  app_type        = "non_interactive"
  oidc_conformant = true
  is_first_party  = true
}

resource "auth0_resource_server" "mogambo-resource-server" {
  name                                            = "Mogambo Resource Server"
  identifier                                      = var.domain
  skip_consent_for_verifiable_first_party_clients = true
  token_dialect                                   = "access_token_authz"
  enforce_policies                                = true
  token_lifetime                                  = var.mogambo_token_lifetime
  token_lifetime_for_web                          = var.mogambo_web_token_lifetime
}

resource "auth0_client_grant" "gateway-resource-server-grant" {
  client_id = auth0_client.mogambo-gateway.client_id
  audience  = var.domain
  scope     = []
}

resource "auth0_client_grant" "gateway-management-api-grant" {
  client_id = auth0_client.mogambo-gateway.client_id
  audience  = var.management_api_identifier
  scope     = var.management_api_scopes
}

resource "auth0_client" "auth0-actions" {
  name            = "Auth0 Actions Application"
  description     = "Application to provide credentials for Auth0 Actions"
  app_type        = "non_interactive"
  oidc_conformant = true

  grant_types = [
    "client_credentials",
  ]
}

resource "auth0_client_grant" "auth0-actions-grant" {
  client_id = auth0_client.auth0-actions.client_id
  audience  = var.management_api_identifier
  scope     = var.auth0_actions_scopes
}
