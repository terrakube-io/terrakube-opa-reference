package terraform.analysis

import rego.v1

# Disallow untrusted third-party providers unless in the approved list
approved_registries := [
	"registry.terraform.io/hashicorp/",
	"registry.opentofu.org/opentofu/",
	"registry.opentofu.org/hashicorp/",
	"registry.terraform.io/integrations/",
	"terrakube-registry.platform.local/"
]

is_approved_provider(provider_name) if {
	some prefix in approved_registries
	startswith(provider_name, prefix)
}

deny contains violation if {
	some name, prov in input.configuration.provider_config
	not is_approved_provider(prov.name)
	violation := {
		"rule_id": "common_trusted_providers",
		"resource": sprintf("provider.%s", [name]),
		"message": sprintf("Provider '%s' is not in the organization's approved registry whitelist.", [prov.name]),
	}
}
