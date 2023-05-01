resource "auth0_action" "add_patient_id_provider_id" {
  name    = "Add Patient and Provider ID"
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
      'contact': 'contact',
      'isLinked': 'is_linked',
      version: 'version'
    };
    const currentVersion = '1.1.1';

    function removeNonNumericAndPlusCharacters(input) {
      return input.replace(/[^0-9+]/g, "");
    }

    exports.onExecutePostLogin = async (event, api) => {
      const o = event.user.user_metadata;
      const m = event.user.app_metadata;
      api.idToken.setCustomClaim(keys.version, currentVersion);
      if (event.authorization && o) {
        if (o[keys.providerId]) {
          api.idToken.setCustomClaim(keys.providerId, o[keys.providerId]);
          api.accessToken.setCustomClaim(keys.providerId, o[keys.providerId]);
        }
        if (o[keys.patientId] && o[keys.contact] && typeof m[keys.isLinked] !== 'undefined') {
          const auth0CompatiblePhNumber = removeNonNumericAndPlusCharacters(o[keys.contact])
          api.idToken.setCustomClaim(keys.patientId, o[keys.patientId]);
          api.accessToken.setCustomClaim(keys.patientId, o[keys.patientId]);
          api.idToken.setCustomClaim(keys.contact, auth0CompatiblePhNumber);
          api.user.setUserMetadata(keys.contact, auth0CompatiblePhNumber);
          api.idToken.setCustomClaim(keys.isLinked, m[keys.isLinked]);
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
        connection: event.connection.name
      };
      // auth0.requestChangePasswordEmail(userAndConnection);
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

  secrets {
    name  = "AUTH0_DOMAIN"
    value = var.auth0_domain
  }

  secrets {
    name  = "AUTH0_CLIENT_ID"
    value = auth0_client.codenames-client.client_id
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
          cacheTTLInSeconds: 10,
        }
      });
      const userId = event.user.user_id;
      const user = await auth0.getUser({ id: userId });
      if(user?.app_metadata?.is_signup) {
        await auth0.updateAppMetadata({ id: userId }, { is_signup: false, is_linked: false });
      }
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
    value = auth0_client.codenames-client.client_id
  }

  secrets {
    name  = "AUTH0_CLIENT_SECRET"
    value = auth0_client.codenames-client.client_secret
  }
}

resource "auth0_trigger_binding" "post_change_password_flow" {
  trigger = "post-change-password"

  actions {
    id           = auth0_action.update_user_metadata_post_signup.id
    display_name = auth0_action.update_user_metadata_post_signup.name
  }
}

resource "auth0_action" "link_related_accounts" {
  name    = "Link related accounts"
  runtime = "node16"
  deploy  = true
  code    = <<-EOT
    /**
    * Handler that will be called during the execution of a PostLogin flow.
    *
    * @param {Event} event - Details about the user and the context in which they are logging in.
    * @param {PostLoginAPI} api - Interface whose methods can be used to change the behavior of the login.
    */

    const AuthClient = require('auth0').ManagementClient;

    exports.onExecutePostLogin = async (event, api) => {
      const auth0 = new AuthClient({
        domain: event.secrets.AUTH0_DOMAIN,
        clientId: event.secrets.AUTH0_CLIENT_ID,
        clientSecret: event.secrets.AUTH0_CLIENT_SECRET,
        tokenProvider: {
          enableCache: true,
          cacheTTLInSeconds: 10,
        }
      });
      if (event.secrets.AUTH0_UNO_CLIENT_ID === event.client.client_id) {
        if (event.user.phone_number && event.connection.name === 'sms') {
          const user = await auth0.getUsers({
            search_engine: 'v3',
            q: `user_metadata.contact:"$${event.user.phone_number}"`,
            per_page: 1,
            page: 0
          })
          const provider = event.user.identities?.[0]?.provider;
          if (user.length && provider) {
            try {
              await auth0.linkUsers(user[0].user_id, {
                user_id: event.user.user_id,
                provider,
                connection_id: event.connection.id
              });
            } catch (e) { 
              console.log("error in linking", e);
            }
          }
          const linkedUser = await auth0.updateAppMetadata({ id: user[0].user_id }, { is_linked: true, is_signup: false })
          console.log("linkedUser", linkedUser)
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
    value = auth0_client.codenames-client.client_id
  }

  secrets {
    name  = "AUTH0_CLIENT_SECRET"
    value = auth0_client.codenames-client.client_secret
  }

  secrets {
    name  = "AUTH0_UNO_CLIENT_ID"
    value = auth0_client.uno-patient-mobile-app.client_id
  }

}

resource "auth0_trigger_binding" "link_related_accounts_flow" {
  trigger = "post-login"

  actions {
    id           = auth0_action.link_related_accounts.id
    display_name = auth0_action.link_related_accounts.name
  }
}

resource "auth0_action" "enable_mfa" {
  name = "Enable MFA For Patients"
  runtime = "node16"
  deploy  = false # This requires us to move from passwordless login to 
  code = <<-EOT
    /**
    * Handler that will be called during the execution of a PostLogin flow.
    *
    * @param {Event} event - Details about the user and the context in which they are logging in.
    * @param {PostLoginAPI} api - Interface whose methods can be used to change the behavior of the login.
    */

    exports.onExecutePostLogin = async (event, api) => {
      
      const CLIENTS_WITH_MFA = [event.secrets.UNO_CLIENT_ID];
      if (CLIENTS_WITH_MFA.indexOf(event.client.client_id) !== -1) {
        api.multifactor.enable("any");
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
   secrets {
    name  = "UNO_CLIENT_ID"
    value = auth0_client.uno-patient-mobile-app.client_id
  }
}