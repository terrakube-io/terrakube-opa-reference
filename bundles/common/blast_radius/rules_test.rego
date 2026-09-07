package terraform.analysis_test

import rego.v1
import data.terraform.analysis

mock_plan_low_deletions := {
	"resource_changes": [
		{"mode": "managed", "change": {"actions": ["delete"]}},
		{"mode": "managed", "change": {"actions": ["create"]}}
	]
}

mock_plan_high_deletions := {
	"resource_changes": [
		{"mode": "managed", "change": {"actions": ["delete"]}},
		{"mode": "managed", "change": {"actions": ["delete"]}},
		{"mode": "managed", "change": {"actions": ["delete"]}},
		{"mode": "managed", "change": {"actions": ["delete"]}},
		{"mode": "managed", "change": {"actions": ["delete"]}},
		{"mode": "managed", "change": {"actions": ["delete"]}}
	]
}

test_blast_radius_safe if {
	violations := analysis.soft_mandatory with input as mock_plan_low_deletions
	count(violations) == 0
}

test_blast_radius_exceeded if {
	violations := analysis.soft_mandatory with input as mock_plan_high_deletions
	count(violations) > 0
	some v in violations
	v.rule_id == "common_blast_radius_deletions"
}
