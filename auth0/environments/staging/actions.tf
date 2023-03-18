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
const currentVersion = '1.1.0';

exports.onExecutePostLogin = async (event, api) => {
  const o = event.user.user_metadata;
  api.idToken.setCustomClaim(keys.version, currentVersion);
  api.accessToken.setCustomClaim(keys.version, currentVersion);

  if (event.authorization && o) {
    if(o[keys.providerId]) {
      api.idToken.setCustomClaim(keys.providerId, o[keys.providerId]);
      api.accessToken.setCustomClaim(keys.providerId, o[keys.providerId]);
    }
    if(o[keys.patientId]) {
      api.idToken.setCustomClaim(keys.patientId,o[keys.patientId]);
      api.accessToken.setCustomClaim(keys.patientId,o[keys.patientId]);
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
