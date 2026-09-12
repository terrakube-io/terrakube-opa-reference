package terraform.analysis_test

import rego.v1
import data.terraform.analysis

mock_plan_len_6 := {
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

mock_plan_len_16 := {
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

mock_plan_len_24 := {
	"resource_changes": [{
		"address": "random_password.db_password",
		"type": "random_password",
		"mode": "managed",
		"change": {
			"actions": ["create"],
			"after": {"length": 24}
		}
	}]
}

# Test that without parameter, dynamic_min does not trigger
test_dynamic_length_inactive_without_param if {
	violations := analysis.deny with input as mock_plan_len_16
	dynamic_violations := [v | some v in violations; v.rule_id == "password_length_dynamic_min"]
	count(dynamic_violations) == 0
}

# Test parameter override with numeric input: min_length = 24
test_dynamic_length_param_override_denies_16 if {
	violations := analysis.deny with input as mock_plan_len_16 with data.terrakube.inputs as {"min_length": 24}
	dynamic_violations := [v | some v in violations; v.rule_id == "password_length_dynamic_min"]
	count(dynamic_violations) == 1
}

test_dynamic_length_param_override_passes_24 if {
	violations := analysis.deny with input as mock_plan_len_24 with data.terrakube.inputs as {"min_length": 24}
	dynamic_violations := [v | some v in violations; v.rule_id == "password_length_dynamic_min"]
	count(dynamic_violations) == 0
}

# Test parameter override with string input: min_length = "24"
test_dynamic_length_param_string_override_denies_16 if {
	violations := analysis.deny with input as mock_plan_len_16 with data.terrakube.inputs as {"min_length": "24"}
	dynamic_violations := [v | some v in violations; v.rule_id == "password_length_dynamic_min"]
	count(dynamic_violations) == 1
}
