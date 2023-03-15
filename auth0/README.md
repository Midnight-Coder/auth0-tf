How to Setup Auth0: 

*. Create Auth0 Account
*. Create Auth0 Tenant
*. Delete Social & Username-Password Databases (Auth0 --> Authentication)
*. Create Machine-To-Machine Application (Name it `Terraform Connection`)
*. Select Management API and choose ALL Permissions
*. Configure `terraform.auto.tfvars`
   *. Navigate to the machine-to-machine application you made in step 3 within Auth0 (for example under Applications -> Applications -> Terraform Connection)
   *. Under basic information you will see `Domain`,`Client ID`, and `Client Secret`. Paste these values into `auth0_domain`, `auth0_client_id`, and `auth0_client_secret` within `local.auto.tfvars` respectively.
   *. Navigate to your Management API under Applications -> APIs -> Auth0 Management API, copy the `Identifier` and paste it under `management_api_identifier` within `terraform.auto.tfvars` 
*. Import branding `terraform import auth0_branding.headlamp_brand <mgmt api identifier>`
*. Navgiate to Authentication
*. Import default username and password auth
   *. Click Database -> Username-Password-Authentication
   *. Copy the Identifier (should look like `col_...`)
   *. run `terraform import auth0_connection.default_username_password_auth <identifier>`
*. Run `terraform apply`