package terraform.analysis_test

import rego.v1
import data.terraform.analysis

mock_plan_soft_violation := {
	"resource_changes": [{
		"address": "random_password.db_password",
		"type": "random_password",
		"mode": "managed",
		"change": {
			"actions": ["create"],
			"after": {"length": 10}
		}
	}]
}

mock_plan_soft_compliant := {
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

test_soft_mandatory_triggers_when_between_8_and_11 if {
	violations := analysis.soft_mandatory with input as mock_plan_soft_violation
	count(violations) == 1
	some v in violations
	v.rule_id == "password_length_soft_mandatory"
}

test_soft_mandatory_passes_when_12_or_greater if {
	violations := analysis.soft_mandatory with input as mock_plan_soft_compliant
	count(violations) == 0
}
