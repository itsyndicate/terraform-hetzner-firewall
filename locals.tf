#-----------------------------------------------------------------------------------------------------------------------
# Locals
#-----------------------------------------------------------------------------------------------------------------------
locals {
  base_firewall_rules = concat(
      var.ssh_source_ips == null ? [] : [
      # Allow all traffic to the ssh port
      {
        description = "Allow Incoming SSH Traffic"
        direction   = "in"
        protocol    = "tcp"
        port        = var.ssh_port
        source_ips  = var.ssh_source_ips
      },
    ],
    # Egress traffic
      !var.allow_egress_traffic ? [] : [
      # Egress ICMP
      {
        description = "Allow Outbound ICMP Ping Requests"
        direction   = "out"
        protocol    = "icmp"
        port        = ""
        destination_ips = ["0.0.0.0/0", "::/0"]
      },
      # Egress DNS tcp
      {
        description = "Allow Outbound TCP DNS Requests"
        direction   = "out"
        protocol    = "tcp"
        port        = "53"
        destination_ips = ["0.0.0.0/0", "::/0"]
      },
      # Egress DNS udp
      {
        description = "Allow Outbound UDP DNS Requests"
        direction   = "out"
        protocol    = "udp"
        port        = "53"
        destination_ips = ["0.0.0.0/0", "::/0"]
      },
      # Egress HTTP
      {
        description = "Allow Outbound HTTP Requests"
        direction   = "out"
        protocol    = "tcp"
        port        = "80"
        destination_ips = ["0.0.0.0/0", "::/0"]
      },
      # Egress HTTPs
      {
        description = "Allow Outbound HTTPS Requests"
        direction   = "out"
        protocol    = "tcp"
        port        = "443"
        destination_ips = ["0.0.0.0/0", "::/0"]
      },
      # Egress NTP
      {
        description = "Allow Outbound UDP NTP Requests"
        direction   = "out"
        protocol    = "udp"
        port        = "123"
        destination_ips = ["0.0.0.0/0", "::/0"]
      }
    ],
      !var.allow_ingress_web ? [] : [
      # Ingress WEB
      {
        description = "Allow Incoming HTTP Connections"
        direction   = "in"
        protocol    = "tcp"
        port        = "80"
        source_ips = ["0.0.0.0/0", "::/0"]
      },
      {
        description = "Allow Incoming HTTPS Connections"
        direction   = "in"
        protocol    = "tcp"
        port        = "443"
        source_ips = ["0.0.0.0/0", "::/0"]
      }
    ],
      var.block_icmp_ping_in ? [] : [
      # Block Ingress ICMP
      {
        description = "Allow Incoming ICMP Ping Requests"
        direction   = "in"
        protocol    = "icmp"
        port        = ""
        source_ips = ["0.0.0.0/0", "::/0"]
      }
    ]
  )

  # create a new firewall list based on base_firewall_rules but with direction-protocol-port as key
  # this is needed to avoid duplicate rules
  firewall_rules = {
    for rule in local.base_firewall_rules :
    format("%s-%s-%s", lookup(rule, "direction", "null"), lookup(rule, "protocol", "null"), lookup(rule, "port", "null"))
    => rule
  }

  # do the same for var.extra_firewall_rules
  extra_firewall_rules = {
    for rule in var.extra_firewall_rules :
    format("%s-%s-%s", lookup(rule, "direction", "null"), lookup(rule, "protocol", "null"), lookup(rule, "port", "null"))
    => rule
  }

  # merge the two lists
  firewall_rules_merged = merge(local.firewall_rules, local.extra_firewall_rules)

  # convert the merged list back to a list
  firewall_rules_list = values(local.firewall_rules_merged)
}
