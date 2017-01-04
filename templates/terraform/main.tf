resource "aws_security_group" "{{ aws_security_group.name }}" {
  name = "{{ aws_security_group.name }}"
  description = "{{ aws_security_group.description }}"
  vpc_id = "{{ aws_security_group.vpc_id }}"
{% if aws_security_group.inbound_rules.internal_all_tcp_ports.enabled %}
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    self = true
  }
{% endif %}
{% if aws_security_group.inbound_rules.internal_all_udp_ports.enabled %}
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "udp"
    self = true
  }
{% endif %}
{% for item in aws_security_group.inbound_rules.custom_ports %}
  ingress {
    from_port = {{ aws_security_group.inbound_rules.custom_ports[item].from_port }}
    to_port = {{ aws_security_group.inbound_rules.custom_ports[item].to_port }}
    protocol = "{{ aws_security_group.inbound_rules.custom_ports[item].protocol }}"
{% if aws_security_group.inbound_rules.custom_ports[item].cidr_blocks == "" %}
    cidr_blocks = ["0.0.0.0/0"]
{% else %}
    cidr_blocks = ["{{ aws_security_group.inbound_rules.custom_ports[item].cidr_blocks }}"]
{% endif %}
  }
{% endfor %}
{% if aws_security_group.outbound_rules.all_ip_protocols.enabled %}
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
{% endif %}
}