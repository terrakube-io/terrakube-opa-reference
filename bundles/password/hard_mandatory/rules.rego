package terraform.analysis

import rego.v1
import data.lib.tfplan

# Hard mandatory rule: Passwords shorter than 8 characters are strictly prohibited
deny contains violation if {
	some res in tfplan.resources_by_type("random_password")
	tfplan.is_create_or_update(res)
	after := tfplan.after_or_empty(res)
	len := after.length
	len < 8
	violation := {
		"rule_id": "password_length_hard_mandatory",
		"resource": res.address,
		"message": sprintf("Password length of %d characters is strictly prohibited (minimum 8 required). Apply is blocked.", [len]),
	}
}
