resource "auth0_branding" "app_brand" {
  logo_url = var.logo_uri

  colors {
    primary         = var.primary_color
    page_background = "#FFFFFF"
  }
}
