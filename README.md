# terraform-hetzner-firewall

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | 1.49.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | 1.49.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [hcloud_firewall.this](https://registry.terraform.io/providers/hetznercloud/hcloud/1.49.1/docs/resources/firewall) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_egress_traffic"></a> [allow\_egress\_traffic](#input\_allow\_egress\_traffic) | Whether or not to allow the egress traffic | `bool` | `true` | no |
| <a name="input_allow_ingress_web"></a> [allow\_ingress\_web](#input\_allow\_ingress\_web) | Whether or not to allow the ingress WEB traffic | `bool` | `false` | no |
| <a name="input_block_icmp_ping_in"></a> [block\_icmp\_ping\_in](#input\_block\_icmp\_ping\_in) | Block ingress ICMP | `bool` | `false` | no |
| <a name="input_extra_firewall_rules"></a> [extra\_firewall\_rules](#input\_extra\_firewall\_rules) | Additional firewall rules to apply to the cluster | `list(any)` | `[]` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A map of labels to add to all resources | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the firewall | `string` | `"my-firewall"` | no |
| <a name="input_ssh_port"></a> [ssh\_port](#input\_ssh\_port) | n/a | `number` | `22` | no |
| <a name="input_ssh_source_ips"></a> [ssh\_source\_ips](#input\_ssh\_source\_ips) | Source networks that have SSH access to the servers | `list(string)` | <pre>[<br/>  "0.0.0.0/0",<br/>  "::/0"<br/>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->