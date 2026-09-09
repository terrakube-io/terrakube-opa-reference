package terraform.analysis_test

import rego.v1
import data.terraform.analysis

mock_plan_hard_violation := {
	"resource_changes": [{
		"address": "random_password.db_password",
		"type": "random_password",
		"mode": "managed",
		"change": {
			"actions": ["create"],
			"after": {"length": 6}
		}
	}]
}

mock_plan_hard_compliant := {
	"resource_changes": [{
		"address": "random_password.db_password",
		"type": "random_password",
		"mode": "managed",
		"change": {
			"actions": ["create"],
			"after": {"length": 16}
		}
	}]
}

test_hard_mandatory_denies_when_less_than_8 if {
	violations := analysis.deny with input as mock_plan_hard_violation
	count(violations) == 1
	some v in violations
	v.rule_id == "password_length_hard_mandatory"
}

test_hard_mandatory_passes_when_8_or_greater if {
	violations := analysis.deny with input as mock_plan_hard_compliant
	count(violations) == 0
}
