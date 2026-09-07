package terraform.analysis

import rego.v1
import data.lib.tags
import data.lib.tfplan

default required_tags := ["Environment", "Owner", "CostCenter"]

# Terrakube supports parameter inputs via data.terrakube.inputs
configured_tags := split(data.terrakube.inputs.required_tags, ",") if {
	data.terrakube.inputs.required_tags != ""
} else := required_tags

# Advisory warning rule for missing resource tags
warn contains violation if {
	some res in tfplan.managed_create_or_update
	# Enforce on AWS, Azure, GCP cloud resources
	regex.match(`^(aws_|azurerm_|google_)`, res.type)
	missing := tags.missing_tags(res, configured_tags)
	count(missing) > 0
	violation := {
		"rule_id": "common_mandatory_tagging",
		"resource": res.address,
		"message": sprintf("Resource is missing mandatory tags: %v", [missing]),
	}
}
