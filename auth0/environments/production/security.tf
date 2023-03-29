resource "auth0_attack_protection" "sensible_defaults" {
  suspicious_ip_throttling {
    enabled = true
    shields = ["admin_notification", "block"]
  }
  brute_force_protection {
    enabled      = true
    max_attempts = 10
    mode         = "count_per_identifier"
    shields      = ["user_notification", "block"]
  }

  breached_password_detection {
    admin_notification_frequency = ["daily"]
    enabled                      = true
    method                       = "standard"
    shields                      = ["admin_notification", "block"]

    pre_user_registration {
      shields = ["block"]
    }
  }
}
