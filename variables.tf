#-----------------------------------------------------------------------------------------------------------------------
# Variables
#-----------------------------------------------------------------------------------------------------------------------
variable "name" {
  type        = string
  default     = "my-firewall"
  description = "Name of the firewall"

}
variable "ssh_source_ips" {
  type = list(string)
  default = ["0.0.0.0/0", "::/0"]
  description = "Source networks that have SSH access to the servers"
}

variable "ssh_port" {
  default = 65321
}

variable "allow_egress_traffic" {
  type        = bool
  default     = true
  description = "Whether or not to allow the egress traffic"
}

variable "allow_ingress_web" {
  type        = bool
  default     = false
  description = "Whether or not to allow the ingress WEB traffic"
}

variable "block_icmp_ping_in" {
  type        = bool
  default     = false
  description = "Block ingress ICMP"
}

variable "extra_firewall_rules" {
  type = list(any)
  default = []
  description = "Additional firewall rules to apply to the cluster"
}

variable "labels" {
  description = "A map of labels to add to all resources"
  type        = map(string)
  default     = {}
}
