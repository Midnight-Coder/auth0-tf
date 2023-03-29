Setting up Auth0: 

1. Create Auth0 Account

2. Create Auth0 Tenant

3. Delete Username-Password Databases (Auth0 --> Authentication --> Database)

4. Delete Social Connection (Auth0 --> Authentication)

5. Create Machine-To-Machine Application (Name it `Terraform Connection`)

6. Select Management API and choose ALL Permissions

7. Create a file `local.auto.tfvars` in the environment directory
   1. Navigate to the machine-to-machine application you made in step 3 within Auth0 (for example under Applications -> Applications -> Terraform Connection)
   2. Under basic information you will see `Domain`,`Client ID`, and `Client Secret`. Paste these values into `auth0_domain`, `auth0_client_id`, and `auth0_client_secret` within `local.auto.tfvars` respectively.
   3. Navigate to your Management API under Applications -> APIs -> Auth0 Management API, copy the `Identifier` and paste it under `management_api_identifier` within `terraform.auto.tfvars`

8. Import branding `terraform import auth0_branding.headlamp_brand <mgmt api identifier>`

9. Navigate to Authentication

10. Run `terraform apply`

11. Terraform does not provide a way to update the Password Reset Experience in Universal Login. Goto Branding -> Universal Login -> Advanced Options -> Password Reset
    1. Enable the option 
    2. Paste custom liquid template auth0/passwordReset.liquid
