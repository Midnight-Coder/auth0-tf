### BRANDING
resource "auth0_branding" "headlamp_brand" {
  logo_url = var.logo_uri

  colors {
    primary         = var.primary_color
    page_background = "#FFFFFF"
  }
}

resource "auth0_email" "sendgrid_email_provider" {
  name                 = "sendgrid"
  enabled              = true
  default_from_address = var.email_from

  credentials {
    api_key = var.sendgrid_key
  }
}

resource "auth0_email_template" "change_password" {
  depends_on              = [auth0_email.sendgrid_email_provider]
  from                    = var.email_from
  template                = "change_password"
  syntax                  = "liquid"
  enabled                 = true
  url_lifetime_in_seconds = 86400
  subject                 = "{% if user.app_metadata.is_signup == true %} {% if user.user_metadata.provider_id %} Headlamp account activation {% else %} Invite from {{ user.user_metadata.provider.name }} {%endif%} {% else %} Reset your password {% endif %}"
  body                    = <<-EOT
{%if user.app_metadata.is_signup == true %}
 {%if user.user_metadata.provider_id %}
	<html>
  <head>
    <style type="text/css">
      .ExternalClass,.ExternalClass div,.ExternalClass font,.ExternalClass p,.ExternalClass span,.ExternalClass td,img {line-height: 100%;}#outlook a {padding: 0;}.ExternalClass,.ReadMsgBody {width: 100%;}a,blockquote,body,li,p,table,td {-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;}table,td {mso-table-lspace: 0;mso-table-rspace: 0;}img {-ms-interpolation-mode: bicubic;border: 0;height: auto;outline: 0;text-decoration: none;}table {border-collapse: collapse !important;}#bodyCell,#bodyTable,body {height: 100% !important;margin: 0;padding: 0;font-family: Roboto, sans-serif;}#bodyCell {padding: 20px;}#bodyTable {width: 600px;}@font-face {font-family: Roboto;src: url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-regular-webfont-webfont.eot);src: url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-regular-webfont-webfont.eot?#iefix)format("embedded-opentype"),url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-regular-webfont-webfont.woff) format("woff");font-weight: 400;font-style: normal;}@font-face {font-family: Roboto;src: url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-semibold-webfont-webfont.eot);src: url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-semibold-webfont-webfont.eot?#iefix)format("embedded-opentype"),url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-semibold-webfont-webfont.woff) format("woff");font-weight: 600;font-style: normal;}@media only screen and (max-width: 480px) {#bodyTable,body {width: 100% !important;}a,blockquote,body,li,p,table,td {-webkit-text-size-adjust: none !important;}body {min-width: 100% !important;}#bodyTable {max-width: 600px !important;}#signIn {max-width: 280px !important;}}
    </style>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto">
  </head>
  <body>
    <center>
      <table
        style='width: 600px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;mso-table-lspace: 0pt;mso-table-rspace: 0pt;margin: 0;padding: 0;font-family: "Roboto", sans-serif;border-collapse: collapse !important;height: 100% !important;'
        align="center"
        border="0"
        cellpadding="0"
        cellspacing="0"
        height="100%"
        width="100%"
        id="bodyTable"
      >
        <tr>
          <td
            align="center"
            valign="top"
            id="bodyCell"
            style='-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;mso-table-lspace: 0pt;mso-table-rspace: 0pt;margin: 0;padding: 20px;font-family: "ProximaNova", sans-serif;height: 100% !important;'
          >
            <div class="main">
              <p>
                <img src="https://lh3.google.com/u/0/d/1-XFV0v_P_OeUeriu31pg8ylj1gghePoc=w3840-h2002-iv3" width="250" alt="Your logo goes here" style="-ms-interpolation-mode: bicubic;border: 0;height: auto;line-height: 100%;outline: none;text-decoration: none;">
               </p>
              <hr style="border: 1px solid #EAEEF3; border-bottom: 0; margin: 20px 0;" />
              <br />

              <h1>Your account is ready to activate</h1>

              <p>Click the button below to set a password and activate your account. </p>
              <p>
                Once activated, you’ll have access to the Headlamp tools.
              </p>

              <p>
                <a href="{{ url }}isSignUp=true&source=provider">
                <button style="font-size: 15px; color: white; background: #33739D; box-shadow: 0px 3px 1px -2px rgba(0, 0, 0, 0.2), 0px 2px 2px rgba(0, 0, 0, 0.14), 0px 1px 5px rgba(0, 0, 0, 0.12); border-radius: 4px; width: 237px; height: 42px; border: 0px;">ACTIVATE YOUR ACCOUNT</button>
                </a>
                <br /><br />
                <hr style="border: 1px dashed #EAEEF3; border-bottom: 0; margin: 20px 0;" />
              <br />
              </p>
              <p>
                Button not working?
              </p>
              <p>
                Try copying and pasting this link into your browser’s address bar:
              </p>
              <p>
        {{ url }}isSignUp=true&source=provider
              </p>
            <br /><br />
              <hr style="border: 1px solid #EAEEF3; border-bottom: 0; margin: 20px 0;" />
            <h3>Questions?</h3>
              <p>
                Email: <a href="mailto:support@headlamp.com" style="text-decoration: none; color: #33739D;">support@headlamp.com</a>
              </p>
            <br />
            <p style="text-align: center;color: #A9B3BC;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%; font-size: 14px;">
              ©2023 Headlamp Health, Inc. All Rights Reserved<br/>
              You’re receiving this email because you signed up for a Headlamp account.
            </p>
            </div>
          </td>
        </tr>
      </table>
    </center>
  </body>
</html>
 {% else %}
 <html>
  <head>
    <style type="text/css">
      .ExternalClass,.ExternalClass div,.ExternalClass font,.ExternalClass p,.ExternalClass span,.ExternalClass td,img {line-height: 100%;}#outlook a {padding: 0;}.ExternalClass,.ReadMsgBody {width: 100%;}a,blockquote,body,li,p,table,td {-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;}table,td {mso-table-lspace: 0;mso-table-rspace: 0;}img {-ms-interpolation-mode: bicubic;border: 0;height: auto;outline: 0;text-decoration: none;}table {border-collapse: collapse !important;}#bodyCell,#bodyTable,body {height: 100% !important;margin: 0;padding: 0;font-family: ProximaNova, sans-serif;}#bodyCell {padding: 20px;}#bodyTable {width: 600px;}@font-face {font-family: ProximaNova;src: url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-regular-webfont-webfont.eot);src: url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-regular-webfont-webfont.eot?#iefix)format("embedded-opentype"),url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-regular-webfont-webfont.woff) format("woff");font-weight: 400;font-style: normal;}@font-face {font-family: ProximaNova;src: url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-semibold-webfont-webfont.eot);src: url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-semibold-webfont-webfont.eot?#iefix)format("embedded-opentype"),url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-semibold-webfont-webfont.woff) format("woff");font-weight: 600;font-style: normal;}@media only screen and (max-width: 480px) {#bodyTable,body {width: 100% !important;}a,blockquote,body,li,p,table,td {-webkit-text-size-adjust: none !important;}body {min-width: 100% !important;}#bodyTable {max-width: 600px !important;}#signIn {max-width: 280px !important;}}
    </style>
  </head>
  <body>
    <center>
      <table
        style='width: 600px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;mso-table-lspace: 0pt;mso-table-rspace: 0pt;margin: 0;padding: 0;font-family: "ProximaNova", sans-serif;border-collapse: collapse !important;height: 100% !important;'
        align="center"
        border="0"
        cellpadding="0"
        cellspacing="0"
        height="100%"
        width="100%"
        id="bodyTable"
      >
        <tr>
          <td
            valign="top"
            id="bodyCell"
            style='-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;mso-table-lspace: 0pt;mso-table-rspace: 0pt;margin: 0;padding: 20px;font-family: "ProximaNova", sans-serif;height: 100% !important;'
          >
            <div class="main">
              <p style="text-align: center;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%; margin-bottom: 30px;">
                <img src="https://lh3.google.com/u/0/d/1-XFV0v_P_OeUeriu31pg8ylj1gghePoc=w3840-h2002-iv3" width="250" alt="Your logo goes here" style="-ms-interpolation-mode: bicubic;border: 0;height: auto;line-height: 100%;outline: none;text-decoration: none;">
              </p>

              <p>Hello {{user.name}},</p>

              <p>
                Your healthcare provider, <b>{{user.user_metadata.provider.name}}</b>, would like you to create a Headlamp Health account and download the mobile app to enable both of you to <b>better understand how you’re doing</b> between appointments.
              </p>
              <p>Select the button below to get started.</p>
              <div style="text-align: center;">
                <a href="{{url}}isSignUp=true&source=patient">
                <button style="
                  height: 39px;
                  width: 100%;
                  left: 0px;
                  top: 24px;
                  border-radius: 12px;
                  padding: 6px 12px 6px 12px;
                  background: #33739D;
                  color: white;
                  ">
                  GET STARTED
                </button>
              </a>
              </div>
              <br /><br/>
              Thanks,
              <p>The Headlamp Team</p>
              <br/>
              <hr style="border: 2px solid #EAEEF3; border-bottom: 0; margin: 20px 0;" />
              <div style="text-align: center;">
                <h3>Questions?</h3>
                <p>
                  Email: <a href="mailto:support@headlamp.com" style="text-decoration: none; color: #33739D;">support@headlamp.com</a>
                </p>
              </div>
            <br />
            <p style="text-align: center;color: #A9B3BC;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%; font-size: 14px;">
              ©2023 Headlamp Health, Inc. All Rights Reserved<br/>
              You’re receiving this email because you signed up for a Headlamp account.
            </p>
            </div>
          </td>
        </tr>
      </table>
    </center>
  </body>
</html>
{% endif %}

{% else %}
<html>
  <head>
    <style type="text/css">
      .ExternalClass,.ExternalClass div,.ExternalClass font,.ExternalClass p,.ExternalClass span,.ExternalClass td,img {line-height: 100%;}#outlook a {padding: 0;}.ExternalClass,.ReadMsgBody {width: 100%;}a,blockquote,body,li,p,table,td {-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;}table,td {mso-table-lspace: 0;mso-table-rspace: 0;}img {-ms-interpolation-mode: bicubic;border: 0;height: auto;outline: 0;text-decoration: none;}table {border-collapse: collapse !important;}#bodyCell,#bodyTable,body {height: 100% !important;margin: 0;padding: 0;font-family: ProximaNova, sans-serif;}#bodyCell {padding: 20px;}#bodyTable {width: 600px;}@font-face {font-family: ProximaNova;src: url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-regular-webfont-webfont.eot);src: url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-regular-webfont-webfont.eot?#iefix)format("embedded-opentype"),url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-regular-webfont-webfont.woff) format("woff");font-weight: 400;font-style: normal;}@font-face {font-family: ProximaNova;src: url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-semibold-webfont-webfont.eot);src: url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-semibold-webfont-webfont.eot?#iefix)format("embedded-opentype"),url(https://cdn.auth0.com/fonts/proxima-nova/proximanova-semibold-webfont-webfont.woff) format("woff");font-weight: 600;font-style: normal;}@media only screen and (max-width: 480px) {#bodyTable,body {width: 100% !important;}a,blockquote,body,li,p,table,td {-webkit-text-size-adjust: none !important;}body {min-width: 100% !important;}#bodyTable {max-width: 600px !important;}#signIn {max-width: 280px !important;}}
    </style>
  </head>
  <body>
    <center>
      <table
        style='width: 600px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;mso-table-lspace: 0pt;mso-table-rspace: 0pt;margin: 0;padding: 0;font-family: "ProximaNova", sans-serif;border-collapse: collapse !important;height: 100% !important;'
        align="center"
        border="0"
        cellpadding="0"
        cellspacing="0"
        height="100%"
        width="100%"
        id="bodyTable"
      >
        <tr>
          <td
            valign="top"
            id="bodyCell"
            style='-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;mso-table-lspace: 0pt;mso-table-rspace: 0pt;margin: 0;padding: 20px;font-family: "ProximaNova", sans-serif;height: 100% !important;'
          >
            <div class="main">
              <p style="text-align: center;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%; margin-bottom: 30px;">
                <img src="https://lh3.google.com/u/0/d/1-XFV0v_P_OeUeriu31pg8ylj1gghePoc=w3840-h2002-iv3" width="250" alt="Your logo goes here" style="-ms-interpolation-mode: bicubic;border: 0;height: auto;line-height: 100%;outline: none;text-decoration: none;">
              </p>

              <p>Hello {{user.name}},</p>

              <p>
                You requested a password change. Click on the link below to change your password.
              </p>
              <div style="text-align: center;">
                <a href="{{url}}isSignUp=false">
                <button style="
                  height: 39px;
                  width: 100%;
                  left: 0px;
                  top: 24px;
                  border-radius: 12px;
                  padding: 6px 12px 6px 12px;
                  background: #33739D;
                  color: white;
                  ">
                  GET STARTED
                </button>
                  </a>
              </div>
              <br /><br/>
              Thanks,
              <p>The Headlamp Team</p>
              <br/>
              <hr style="border: 2px solid #EAEEF3; border-bottom: 0; margin: 20px 0;" />
              <div style="text-align: center;">
                <h3>Questions?</h3>
                <p>
                  Email: <a href="mailto:support@headlamp.com" style="text-decoration: none; color: #33739D;">support@headlamp.com</a>
                </p>
              </div>
            <br />
            <p style="text-align: center;color: #A9B3BC;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%; font-size: 14px;">
              ©2023 Headlamp Health, Inc. All Rights Reserved<br/>
              You’re receiving this email because you signed up for a Headlamp account.
            </p>
            </div>
          </td>
        </tr>
      </table>
    </center>
  </body>
</html>
{% endif %}
  EOT
}

### ORGANIZATIONS
resource "auth0_organization" "default_org" {
  name         = "headlamp"
  display_name = "Headlamp Health Inc."
}

### AUTHENTICATION CONNECTIONS CONFIGS
resource "auth0_connection" "provider-authentication" {
  name                 = "provider-authentication"
  is_domain_connection = true
  strategy             = "auth0"
  options {
    brute_force_protection         = true
    disable_signup                 = false
    enabled_database_customization = false
    from                           = var.email_from
    import_mode                    = false
    password_policy                = "excellent"
    requires_username              = false
  }
}

resource "auth0_connection" "patient-authentication" {
  name                 = "patient-authentication"
  is_domain_connection = true
  strategy             = "auth0"
  options {
    brute_force_protection         = true
    disable_signup                 = false
    enabled_database_customization = false
    from                           = var.email_from
    import_mode                    = false
    password_policy                = "excellent"
    requires_username              = false
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

data "auth0_client" "uno_patient_mobile_app" {
  name = "Headlamp Health App"
}

data "auth0_client" "management_api_app" {
  name = "Terraform Connection"
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
