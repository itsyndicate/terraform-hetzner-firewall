mock_provider "hcloud" {}

variables {
  name = "test-firewall"
}

run "writes_the_base_rules_by_default" {
  command = plan

  variables {
    ssh_source_ips       = ["203.0.113.0/24"]
    allow_egress_traffic = true
    allow_ingress_web    = false
    block_icmp_ping_in   = false
    extra_firewall_rules = []
  }

  assert {
    condition     = length([for r in hcloud_firewall.this.rule : r if r.direction == "out"]) == 6
    error_message = "allow_egress_traffic = true writes six outbound rules"
  }

  assert {
    condition     = length([for r in hcloud_firewall.this.rule : r if r.direction == "in" && r.protocol == "tcp" && r.port == "22"]) == 1
    error_message = "A non-null ssh_source_ips writes the SSH rule"
  }

  assert {
    condition     = length([for r in hcloud_firewall.this.rule : r if r.protocol == "icmp" && r.direction == "in"]) == 1
    error_message = "block_icmp_ping_in = false ALLOWS ICMP. The flag reads backwards"
  }
}

run "suppresses_every_base_rule" {
  command = plan

  variables {
    ssh_source_ips       = null
    allow_egress_traffic = false
    allow_ingress_web    = false
    block_icmp_ping_in   = true
    extra_firewall_rules = []
  }

  assert {
    condition     = length(hcloud_firewall.this.rule) == 0
    error_message = "The four suppression flags must leave no rule at all"
  }
}

run "adds_only_the_extra_rules_when_the_base_is_suppressed" {
  command = plan

  variables {
    ssh_source_ips       = null
    allow_egress_traffic = false
    allow_ingress_web    = false
    block_icmp_ping_in   = true

    extra_firewall_rules = [
      {
        description = "All TCP from the operator"
        direction   = "in"
        protocol    = "tcp"
        port        = "any"
        source_ips  = ["203.0.113.10/32"]
      },
      {
        description = "ICMP from the operator"
        direction   = "in"
        protocol    = "icmp"
        port        = ""
        source_ips  = ["203.0.113.10/32"]
      },
    ]
  }

  assert {
    condition     = length(hcloud_firewall.this.rule) == 2
    error_message = "Only the two extra rules survive"
  }

  assert {
    condition     = length([for r in hcloud_firewall.this.rule : r if r.direction == "out"]) == 0
    error_message = "An empty outbound set is what makes Hetzner allow all egress"
  }
}

run "an_extra_rule_overrides_a_base_rule_on_the_same_key" {
  command = plan

  variables {
    ssh_source_ips       = ["0.0.0.0/0"]
    allow_egress_traffic = false
    allow_ingress_web    = false
    block_icmp_ping_in   = true

    extra_firewall_rules = [
      {
        description = "SSH from the operator only"
        direction   = "in"
        protocol    = "tcp"
        port        = "22"
        source_ips  = ["203.0.113.10/32"]
      },
    ]
  }

  assert {
    condition     = length(hcloud_firewall.this.rule) == 1
    error_message = "Both rules key on in-tcp-22, so merge() keeps one"
  }

  assert {
    condition     = one([for r in hcloud_firewall.this.rule : r.source_ips]) == toset(["203.0.113.10/32"])
    error_message = "merge() takes the extra rule, silently dropping the base rule"
  }
}
