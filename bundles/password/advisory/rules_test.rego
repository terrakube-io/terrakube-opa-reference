package terraform.analysis_test

import rego.v1
import data.terraform.analysis

mock_plan_short_advisory := {
	"resource_changes": [{
		"address": "random_password.db_password",
		"type": "random_password",
		"mode": "managed",
		"change": {
			"actions": ["create"],
			"after": {"length": 14}
		}
	}]
}

mock_plan_compliant := {
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

test_advisory_warns_when_between_12_and_15 if {
	violations := analysis.warn with input as mock_plan_short_advisory
	count(violations) == 1
	some v in violations
	v.rule_id == "password_length_advisory"
}

test_advisory_passes_when_16_or_greater if {
	violations := analysis.warn with input as mock_plan_compliant
	count(violations) == 0
}
