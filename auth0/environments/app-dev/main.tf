### ORGANIZATIONS
resource "auth0_organization" "default_org" {
  name         = "supercmo"
  display_name = "Super CMO"
}

### AUTHENTICATION CONFIG
resource "auth0_connection" "google_oauth2" {
  name     = "social-google-oauth2"
  strategy = "google-oauth2"
}

resource "auth0_connection_client" "gogo_google_assoc" {
  connection_id = auth0_connection.google_oauth2.id
  client_id     = auth0_client.gogo-frontend-console.id
}
