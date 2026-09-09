package terraform.analysis

import rego.v1
import data.lib.tfplan

# Advisory rule: Warn if password length is between 12 and 15 characters
warn contains violation if {
	some res in tfplan.resources_by_type("random_password")
	tfplan.is_create_or_update(res)
	after := tfplan.after_or_empty(res)
	len := after.length
	len >= 12
	len < 16
	violation := {
		"rule_id": "password_length_advisory",
		"resource": res.address,
		"message": sprintf("Password length is %d characters. While acceptable, 16 or more characters is strongly recommended.", [len]),
	}
}
