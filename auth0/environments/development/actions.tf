resource "auth0_action" "add-orgs-to-jwt" {
  name    = "Add User's Membership to Organizations ID Token JWT"
  runtime = "node18"
  deploy  = true
  code    = <<-EOT
    /**
      * Handler that will be called during the execution of a PostLogin flow.
      *
      * @param {Event} event - Details about the user and the context in which they are logging in.
      * @param {PostLoginAPI} api - Interface whose methods can be used to change the behavior of the login.
      */

      const appName = 'gogo';

      const AuthClient = require('auth0').ManagementClient;

      const keys = {
        allOrgs: `${appName}_all_orgs`,
        permissions: `${appName}_permissions`,
        error: `${appName}_error`,
        version: `${appName}_version`,
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
}

resource "auth0_trigger_binding" "post_login_flow" {
  trigger = "post-login"

  actions {
    id           = auth0_action.add-orgs-to-jwt.id
    display_name = auth0_action.add-orgs-to-jwt.name
  }
}