package lib.networking

import rego.v1

# Checks if a CIDR block allows unrestricted internet access
is_open_to_internet(cidr) := cidr in ["0.0.0.0/0", "::/0"]

# Checks if a port number or range includes sensitive admin ports (22 for SSH, 3389 for RDP)
is_sensitive_port(port) := port in [22, 3389, "22", "3389"]
