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
}
