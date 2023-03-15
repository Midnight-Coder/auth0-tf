/*
TODO:
1. branding: 
    1. email provider = send grid
    2. email template
    3. Change password template (universal login)
2. organization: "headlamp"
*/
### BRANDING
resource "auth0_branding" "headlamp_brand" {
  logo_url = var.logo_uri

  colors {
    primary         = "#247AB2"
    page_background = "#FFFFFF"
  }
}

### AUTHENTICATION CONFIGS
resource "auth0_connection" "default_username_password_auth" {
  name                 = "headlamp-sign-in"
  is_domain_connection = true
  strategy             = "auth0"
  options {
    password_policy                = "excellent"
    brute_force_protection         = true
    enabled_database_customization = true
    import_mode                    = false
    requires_username              = true
    disable_signup                 = false
  }
}

### SECURITY CONFIGS
resource "auth0_attack_protection" "sensible_defaults" {
  suspicious_ip_throttling {
    enabled = true
    shields = ["admin_notification", "block"]
  }
  brute_force_protection {
    enabled      = true
    max_attempts = 10
    mode         = "count_per_identifier"
    shields      = ["user_notification", "block"]
  }

  breached_password_detection {
    admin_notification_frequency = ["daily"]
    enabled                      = true
    method                       = "standard"
    shields                      = ["admin_notification", "block"]

    pre_user_registration {
      shields = ["block"]
    }
  }
}

### REGISTER CLIENTS
resource "auth0_client" "azul-provider-console" {
  name                       = "Headlamp Health"
  description                = "Headlamp Console For Providers"
  app_type                   = "spa"
  oidc_conformant            = true
  token_endpoint_auth_method = "none"
  initiate_login_uri         = var.azul_login_uri
  callbacks                  = var.azul_callbacks
  allowed_logout_urls        = var.azul_logouts
  web_origins                = var.azul_web_origins
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
  callbacks                  = var.uno_callbacks
  allowed_logout_urls        = var.uno_logouts
  web_origins                = var.uno_web_origins
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
  identifier                                      = var.jenga_api_identifier
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

resource "auth0_resource_server" "senet-resource-server" {
  name                                            = "Senet Resource Server"
  identifier                                      = var.senet_api_identifier
  skip_consent_for_verifiable_first_party_clients = true
  token_dialect                                   = "access_token_authz"
  enforce_policies                                = true
  token_lifetime                                  = var.senet_token_lifetime
}


### REGISTER ACTIONS
resource "auth0_action" "add_patient_id_provider_id" {
  name    = "Add Patient and Provide ID"
  runtime = "node16"
  deploy  = true
  code    = <<-EOT
/**
* Handler that will be called during the execution of a PostLogin flow.
*
* @param {Event} event - Details about the user and the context in which they are logging in.
* @param {PostLoginAPI} api - Interface whose methods can be used to change the behavior of the login.
*/

const keys = {
  'patientId': 'patient_id',
  'providerId': 'provider_id',
  version: 'version'
};
const currentVersion = '1.0.0';

exports.onExecutePostLogin = async (event, api) => {
  const o = event.user.user_metadata;
  api.idToken.setCustomClaim(keys.version, currentVersion);
  if (event.authorization && o) {
    if(o[keys.providerId]) {
    api.idToken.setCustomClaim(keys.providerId, o[keys.providerId]);
    }
    if(o[keys.patientId]) {
     api.idToken.setCustomClaim(keys.patientId,o[keys.patientId]);
   }
  }
};


/**
* Handler that will be invoked when this action is resuming after an external redirect. If your
* onExecutePostLogin function does not perform a redirect, this function can be safely ignored.
*
* @param {Event} event - Details about the user and the context in which they are logging in.
* @param {PostLoginAPI} api - Interface whose methods can be used to change the behavior of the login.
*/
// exports.onContinuePostLogin = async (event, api) => {
// };

  EOT

  supported_triggers {
    id      = "post-login"
    version = "v3"
  }
}

resource "auth0_trigger_binding" "post_login_flow" {
  trigger = "post-login"

  actions {
    id           = auth0_action.add_patient_id_provider_id.id
    display_name = auth0_action.add_patient_id_provider_id.name
  }
}

resource "auth0_action" "send_signup_email" {
  name    = "Send Set Password Email On Signup"
  runtime = "node16"
  deploy  = true
  code    = <<-EOT
/**
* Handler that will be called during the execution of a PostUserRegistration flow.
*
* @param {Event} event - Details about the context and user that has registered.
* @param {PostUserRegistrationAPI} api - Methods and utilities to help change the behavior after a signup.
*/
const AuthClient = require('auth0').AuthenticationClient;

exports.onExecutePostUserRegistration = async (event, api) => {
  const auth0 = new AuthClient({
    domain: event.secrets.AUTH0_DOMAIN,
    clientId: event.secrets.AUTH0_CLIENT_ID
  });
   const userAndConnection = {
    email: event.user.email,
    connection: 'Username-Password-Authentication'
  };
  auth0.requestChangePasswordEmail(userAndConnection);
};

    EOT

  supported_triggers {
    id      = "post-user-registration"
    version = "v2"
  }

  dependencies {
    name    = "auth0"
    version = "3.2.0"
  }

}

resource "auth0_trigger_binding" "post_signup_flow" {
  trigger = "post-user-registration"

  actions {
    id           = auth0_action.send_signup_email.id
    display_name = auth0_action.send_signup_email.name
  }
}

resource "auth0_action" "update_user_metadata_post_signup" {
  name    = "Reset is_signup on user metadata"
  runtime = "node16"
  deploy  = true
  code    = <<-EOT
/**
* Handler that will be called during the execution of a PostChangePassword flow.
*
* @param {Event} event - Details about the user and the context in which the change password is happening.
* @param {PostChangePasswordAPI} api - Methods and utilities to help change the behavior after a user changes their password.
*/

const AuthClient = require('auth0').ManagementClient;

exports.onExecutePostChangePassword = async (event, api) => {
  const auth0 = new AuthClient({
    domain: event.secrets.AUTH0_DOMAIN,
    clientId: event.secrets.AUTH0_CLIENT_ID,
    clientSecret: event.secrets.AUTH0_CLIENT_SECRET,
    tokenProvider: {
      enableCache: true,
      cacheTTLInSeconds: 10
    }
  });
  const userId = event.user.user_id;
  const resp = await auth0.updateAppMetadata({ id: userId }, { is_signup: false })
};

  EOT
  supported_triggers {
    id      = "post-change-password"
    version = "v2"
  }

  dependencies {
    name    = "auth0"
    version = "3.2.0"
  }

  secrets {
    name  = "AUTH0_DOMAIN"
    value = var.auth0_domain
  }

  secrets {
    name  = "AUTH0_CLIENT_ID"
    value = var.auth0_client_id
  }

  secrets {
    name  = "AUTH0_CLIENT_SECRET"
    value = var.auth0_client_secret
  }
}

resource "auth0_trigger_binding" "post_change_password_flow" {
  trigger = "post-change-password"

  actions {
    id           = auth0_action.update_user_metadata_post_signup.id
    display_name = auth0_action.update_user_metadata_post_signup.name
  }
}
