resource "auth0_action" "setup-user" {
  name    = "Send user and org details to app server"
  runtime = "node18"
  deploy  = true
  code    = <<-EOT
  const AuthClient = require('auth0').ManagementClient;
  const https = require('https');
  const BASE_URL_HOST = 'app-dev.supercmo.ai';

  const makePostAPICall = (data, endpoint, accessToken) => {
      return new Promise((resolve, reject) => {
          const options = {
              hostname: BASE_URL_HOST,
              path: endpoint,
              method: 'POST',
              headers: {
                  'Content-Type': 'application/json',
                  Authorization: `Bearer ${accessToken}`
              },
          };

          const req = https.request(options, (res) => {
              let responseData = '';

              res.on('data', (chunk) => {
                  responseData += chunk;
              });

              res.on('end', () => {
                  resolve(responseData);
              });
          });

          req.on('error', (error) => {
              reject(`Error making the request: ${error.message}`);
          });

          req.write(JSON.stringify(data));

          req.end();
      })
  }

  exports.onExecutePostLogin = async (event) => {
    const management = new AuthClient({
      domain: event.secrets.domain,
      clientId: event.secrets.clientId,
      clientSecret: event.secrets.clientSecret,
    });

    let orgs = [];
    try {
      orgs = await management.users.getUserOrganizations({ id: event.user.user_id });
    } catch {
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
          await makePostAPICall(data, '/api/v1/users/organizations/association', accessToken);
        } catch {}
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
    value = auth0_client.auth0 - actions.client_id
  }
  secrets {
    name  = "clientSecret"
    value = auth0_client.auth0 - actions.client_secret
  }
}
resource "auth0_trigger_binding" "post_login_flow" {
  trigger = "post-login"
  actions {
    id           = auth0_action.add - orgs - to - jwt.id
    display_name = auth0_action.add - orgs - to - jwt.name
  }
}
