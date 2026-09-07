package terraform.analysis

import rego.v1
import data.lib.networking
import data.lib.tfplan

# Rule 1: Azure Storage Accounts must require HTTPS and TLS 1.2+
deny contains violation if {
	some res in tfplan.resources_by_type("azurerm_storage_account")
	tfplan.is_create_or_update(res)
	after := tfplan.after_or_empty(res)

	is_insecure_storage(after)
	violation := {
		"rule_id": "azure_storage_secure_transfer",
		"resource": res.address,
		"message": "Azure Storage Accounts must have enable_https_traffic_only = true and min_tls_version = 'TLS1_2'.",
	}
}

is_insecure_storage(after) if {
	after.enable_https_traffic_only == false
}

is_insecure_storage(after) if {
	after.min_tls_version != "TLS1_2"
}

# Rule 2: Azure NSGs must not expose SSH (22) or RDP (3389) directly to the Internet
deny contains violation if {
	some res in tfplan.resources_by_type("azurerm_network_security_rule")
	tfplan.is_create_or_update(res)
	after := tfplan.after_or_empty(res)

	after.access == "Allow"
	after.direction == "Inbound"
	is_internet_source(after.source_address_prefix)
	networking.is_sensitive_port(after.destination_port_range)

	violation := {
		"rule_id": "azure_nsg_no_public_admin_ports",
		"resource": res.address,
		"message": sprintf("Inbound security rule permits unrestricted internet access to sensitive port '%v'.", [after.destination_port_range]),
	}
}

is_internet_source(src) if {
	src in ["0.0.0.0/0", "*", "Internet"]
}
