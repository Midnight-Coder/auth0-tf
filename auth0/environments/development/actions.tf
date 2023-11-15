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


resource "auth0_action" "invite-user-to-flow" {
  name    = "Send user and org details to app server"
  runtime = "node18"
  deploy  = true
  code    = <<-EOT
  const AuthClient = require('auth0').ManagementClient;
  const https = require('https');

  const makePostAPICall = (data, endpoint, accessToken) => {
      return new Promise((resolve, reject) => {
          const options = {
              path: endpoint,
              method: 'POST',
              headers: {
                  'Content-Type': 'application/json',
                  Authorization: 'Bearer ' + accessToken,
              },
          };

          const req = https.request(new URL("${var.domain}"), options, (res) => {
              let responseData = '';

              res.on('data', (chunk) => {
                  responseData += chunk;
              });

              res.on('end', () => {
                  resolve(responseData);
              });
          });

          req.on('error', (error) => {
              reject('Error making the request:' + error.message);
          });

          req.write(JSON.stringify(data));

          req.end();
      })
  }

  const userOrgAssociationEndPoint = '/api/v1/users/organizations/association';
  exports.onExecutePostLogin = async (event) => {
    const management = new AuthClient({
      domain: event.secrets.domain,
      clientId: event.secrets.clientId,
      clientSecret: event.secrets.clientSecret,
    });

    let orgs = [];
    try {
      orgs = await management.users.getUserOrganizations({ id: event.user.user_id });
    } catch(e) {
      console.error(e.message)
      orgs = [];
    }
    const accessToken = await management.getAccessToken();
    const userDetails = {
      firstName: event.user.name,
      lastName: event.user.family_name || '',
      email: event.user.email,
      createdByUserId: event.user.user_id
    };
    const isInvitedUser = Boolean(event?.request?.query?.invitation);
    const invitedOrgId = event?.request?.query?.organization;
    const isInvitedToOrg = Boolean(invitedOrgId);

    if (isInvitedUser && isInvitedToOrg) {
      const orgDetails = orgs.find(o => o.id === invitedOrgId);
      if (orgDetails) {
        const data = {
          user: userDetails, 
          organization: orgDetails
        };
        try {
          await makePostAPICall(data, userOrgAssociationEndPoint, accessToken);
        } catch(e) {
          console.error(e.message);
        }
      }
    }
  }; 
  EOT

  supported_triggers {
    id      = "post-login"
    version = "v1"
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
resource "auth0_trigger_binding" "post_login_user_org_association" {
  trigger = "post-login"
  actions {
    id           = auth0_action.invite-user-to-flow.id
    display_name = auth0_action.invite-user-to-flow.name
  }
}
