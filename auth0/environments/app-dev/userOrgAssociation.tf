resource "auth0_action" "setup-user" {
  name = "Send user and org details to app server"
  runtime = "node18"
  deploy = true
  code   = <<-EOT
  /**
    * Handler that will be called during the execution of a PostLogin flow.
    *
    * @param {Event} event - Details about the user and the context in which they are logging in.
  */

  const AuthClient = require('auth0').ManagementClient;
  const http = require('http');

  const axios = require('axios');
  const BASE_URL = 'https://56b6-103-199-226-156.ngrok-free.app';

  const makePostApiCall = (data, accessToken, endPoint) => {
    return new Promise((resolve, reject) => {
      const options = {
        hostname: BASE_URL,
        path: endPoint,
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${accessToken}`,
        },
      }

      const req = http.request(options, (res) => {
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

      req.write(data);

      req.end();
    });
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
    try {
      await makePostApiCall({ isInvitedToOrg, isInvitedUser, invitedOrgId }, accessToken, '/json');
    } catch { }

    if (isInvitedUser && isInvitedToOrg) {
      const orgDetails = orgs.find(o => o.id === invitedOrgId);
      if (orgDetails) {
        // change axios to fetch
        await makePostApiCall({
          user: userDetails,
          organization: orgDetails
        }, accessToken, '/json');
        // await makePostApiCall(data, accessToken, '/api/v1/users/organizations/association');
      }
    }
  };

  EOT

  supported_triggers {
    id = "post-login"
    version = "v1"
  }

   dependencies {
    name = "auth0"
    version = "3.3.0"
  }
  secrets {
    name = "domain"
    value = var.auth0_domain
  }
  secrets {
    name = "clientId"
    value = auth0_client.auth0 - actions.client_id
  }
  secrets {
    name = "clientSecret"
    value = auth0_client.auth0 - actions.client_secret
  }
}
resource "auth0_trigger_binding" "post_add_user_membership_flow" {
  trigger = "post-login"
  actions {
    id = auth0_action.add - orgs - to - jwt.id
    display_name = auth0_action.add - orgs - to - jwt.name
  }
}
