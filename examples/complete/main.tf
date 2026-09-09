#-----------------------------------------------------------------------------------------------------------------------
# Firewall
#-----------------------------------------------------------------------------------------------------------------------
module "firewall" {
  source = "../../"

  name = "example-complete"

  ssh_source_ips       = null
  allow_ingress_web    = false
  allow_egress_traffic = false
  block_icmp_ping_in   = true

  extra_firewall_rules = [
    {
      description = "All TCP from the operator addresses"
      direction   = "in"
      protocol    = "tcp"
      port        = "any"
      source_ips  = ["203.0.113.10/32"]
    },
    {
      description = "HTTPS from the edge"
      direction   = "in"
      protocol    = "tcp"
      port        = "443"
      source_ips  = ["198.51.100.0/24"]
    },
  ]

  labels = {
    Environment = "example"
    ManagedBy   = "Terraform"
  }
}
