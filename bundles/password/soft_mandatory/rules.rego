package terraform.analysis

import rego.v1
import data.lib.tfplan

# Soft mandatory rule: Flag password length between 8 and 11 characters (requires SecOps override)
soft_mandatory contains violation if {
	some res in tfplan.resources_by_type("random_password")
	tfplan.is_create_or_update(res)
	after := tfplan.after_or_empty(res)
	len := after.length
	len >= 8
	len < 12
	violation := {
		"rule_id": "password_length_soft_mandatory",
		"resource": res.address,
		"message": sprintf("Password length of %d characters is below organizational standard (min 12). Requires SecOps override approval.", [len]),
	}
}
