#-----------------------------------------------------------------------------------------------------------------------
# Variables
#-----------------------------------------------------------------------------------------------------------------------
variable "name" {
  description = "Name of the firewall"
  type        = string
  default     = "my-firewall"
}

variable "ssh_source_ips" {
  description = "Source networks that have SSH access to the servers"
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
}

variable "ssh_port" {
  description = "TCP port the incoming SSH rule opens"
  type        = number
  default     = 22
}

variable "allow_egress_traffic" {
  description = "Whether or not to allow the egress traffic"
  type        = bool
  default     = true
}

variable "allow_ingress_web" {
  description = "Whether or not to allow the ingress WEB traffic"
  type        = bool
  default     = false
}

variable "block_icmp_ping_in" {
  description = "Block ingress ICMP"
  type        = bool
  default     = false
}

variable "extra_firewall_rules" {
  description = "Additional firewall rules to apply to the cluster"
  type        = list(any)
  default     = []
}

variable "labels" {
  description = "A map of labels to add to all resources"
  type        = map(string)
  default     = {}
}
