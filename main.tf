resource "hcloud_firewall" "this" {
  name   = var.name
  labels = var.labels

  dynamic "rule" {
    for_each = local.firewall_rules_list
    content {
      description = rule.value.description
      direction   = rule.value.direction
      protocol    = rule.value.protocol
      port = lookup(rule.value, "port", null)
      destination_ips = lookup(rule.value, "destination_ips", [])
      source_ips = lookup(rule.value, "source_ips", [])
    }
  }
}
