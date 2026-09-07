package lib.networking_test

import rego.v1
import data.lib.networking

test_open_to_internet if {
	networking.is_open_to_internet("0.0.0.0/0")
	networking.is_open_to_internet("::/0")
	not networking.is_open_to_internet("10.0.0.0/8")
	not networking.is_open_to_internet("192.168.1.0/24")
}

test_sensitive_ports if {
	networking.is_sensitive_port(22)
	networking.is_sensitive_port(3389)
	not networking.is_sensitive_port(80)
	not networking.is_sensitive_port(443)
}
