resource "auth0_action" "add-orgs-to-jwt" {
  name    = "Add User's Membership to Organizations ID Token JWT"
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

      const keys = {
        allOrgs: 'gogo_all_orgs',
        permissions: 'gogo_permissions',
        error: 'gogo_error',
        version: 'gogo_version',
      };

      exports.onExecutePostLogin = async (event, api) => {
        const management = new AuthClient({
            domain: event.secrets.domain,
            clientId: event.secrets.clientId,
            clientSecret: event.secrets.clientSecret,
        });
        
        // Set app version
        api.idToken.setCustomClaim(keys.version, '0.0.1');
        
        try {
          // Attempt to access information about all organizations the user belongs to
          const orgs = await management.users.getUserOrganizations({ id: event.user.user_id });
        
          api.idToken.setCustomClaim(keys.allOrgs, orgs);
        } catch (e) {
          api.idToken.setCustomClaim(keys.allOrgs, []);
          api.idToken.setCustomClaim(keys.error, e);
        }
      };
  EOT

  supported_triggers {
    id      = "post-login"
    version = "v3"
  }

  dependencies {
    name    = "auth0"
    version = "3.3.0"
  }
  secrets {
    name  = "domain"
    value = var.auth0_domain
  }
  secrets {
    name  = "clientId"
    value = auth0_client.auth0-actions.client_id
  }
  secrets {
    name  = "clientSecret"
    value = auth0_client.auth0-actions.client_secret
  }
}
resource "auth0_trigger_binding" "post_login_flow" {
  trigger = "post-login"
  actions {
    id           = auth0_action.add-orgs-to-jwt.id
    display_name = auth0_action.add-orgs-to-jwt.name
  }
}