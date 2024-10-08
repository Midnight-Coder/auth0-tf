terraform {
  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "0.44.0"
    }
  }

  cloud {
    organization = "super-cmo"
    workspaces {
      name = "app-dev"
    }
  }

}

provider "auth0" {
  domain        = var.auth0_domain
  client_id     = var.auth0_client_id
  client_secret = var.auth0_client_secret
}
