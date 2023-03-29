terraform {
  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "0.44.0"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "Headlamp-Health"

    workspaces {
      name = "development"
    }
  }
}

provider "auth0" {
  domain        = var.auth0_domain
  client_id     = var.auth0_client_id
  client_secret = var.auth0_client_secret
}
