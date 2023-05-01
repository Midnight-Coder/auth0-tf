### ORGANIZATIONS
resource "auth0_organization" "default_org" {
  name         = "headlamp"
  display_name = "Headlamp Health Inc."
}

### ROLE
resource "auth0_role" "administrator" {
  name        = "administrator"
  description = "Administrator"
}

### AUTHENTICATION CONFIGS
resource "auth0_connection" "provider-authentication" {
  name                 = "provider-authentication"
  is_domain_connection = true
  strategy             = "auth0"
  options {
    brute_force_protection         = true
    disable_signup                 = true
    enabled_database_customization = false
    from                           = var.email_from
    import_mode                    = false
    password_policy                = "excellent"
    requires_username              = false
  }
}

resource "auth0_connection" "patient-authentication" {
  name                 = "patient-authentication"
  is_domain_connection = false
  strategy             = "auth0"
  options {
    brute_force_protection         = true
    disable_signup                 = true
    enabled_database_customization = false
    from                           = var.email_from
    import_mode                    = false
    password_policy                = "excellent"
    requires_username              = false
  }
}

### CLIENT <> RESOURCE SERVER GRANTS
resource "auth0_client_grant" "codenames-jenga-grant" {
  client_id = auth0_client.jenga-gateway.client_id
  audience  = auth0_resource_server.codenames-user-management.identifier
  scope     = var.codenames_scopes
}

resource "auth0_client_grant" "codenames-senet-grant" {
  client_id = auth0_client.senet-gateway.client_id
  audience  = auth0_resource_server.codenames-user-management.identifier
  scope     = var.codenames_scopes
}

resource "auth0_client_grant" "codenames_grant" {
  client_id = auth0_client.codenames-client.client_id
  audience  = var.management_api_identifier
  scope     = var.codenames_scopes
}

### CONNECTION <> CLIENTS
resource "auth0_connection_client" "azul-provider-authentication" {
  connection_id = auth0_connection.provider-authentication.id
  client_id     = auth0_client.azul-provider-console.id
  depends_on = [
    auth0_connection.provider-authentication,
    auth0_client.azul-provider-console
  ]
}

resource "auth0_connection_client" "uno-patient-authentication" {
  connection_id = auth0_connection.patient-authentication.id
  client_id     = auth0_client.uno-patient-mobile-app.id
  depends_on = [
    auth0_connection.patient-authentication,
    auth0_client.uno-patient-mobile-app
  ]
}
