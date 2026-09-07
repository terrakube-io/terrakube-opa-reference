package terraform.analysis_test

import rego.v1
import data.terraform.analysis

mock_plan_valid_provider := {
	"configuration": {
		"provider_config": {
			"aws": {"name": "registry.terraform.io/hashicorp/aws"}
		}
	}
}

mock_plan_invalid_provider := {
	"configuration": {
		"provider_config": {
			"custom": {"name": "untrusted-registry.io/evil/provider"}
		}
	}
}

test_approved_provider_passes if {
	violations := analysis.deny with input as mock_plan_valid_provider
	count(violations) == 0
}

test_unapproved_provider_fails if {
	violations := analysis.deny with input as mock_plan_invalid_provider
	count(violations) == 1
	some v in violations
	v.rule_id == "common_trusted_providers"
}
