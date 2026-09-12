package terraform.analysis

import rego.v1
import data.lib.tfplan

# Terrakube policy set parameters are injected under data.terrakube.inputs
configured_min_length := to_number(data.terrakube.inputs.min_length) if {
	data.terrakube.inputs.min_length != ""
}

# Hard mandatory rule: Password length must meet or exceed configured min_length parameter
deny contains violation if {
	some res in tfplan.resources_by_type("random_password")
	tfplan.is_create_or_update(res)
	after := tfplan.after_or_empty(res)
	len := after.length
	len < configured_min_length
	violation := {
		"rule_id": "password_length_dynamic_min",
		"resource": res.address,
		"message": sprintf("Password length of %d characters is below required threshold (%d). Apply is blocked.", [len, configured_min_length]),
	}
}
