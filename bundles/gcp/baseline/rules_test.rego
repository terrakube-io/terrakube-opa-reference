package terraform.analysis_test

import rego.v1
import data.terraform.analysis

mock_plan_insecure_bucket := {
	"resource_changes": [{
		"address": "google_storage_bucket.data",
		"type": "google_storage_bucket",
		"mode": "managed",
		"change": {
			"actions": ["create"],
			"after": {"uniform_bucket_level_access": false}
		}
	}]
}

mock_plan_secure_bucket := {
	"resource_changes": [{
		"address": "google_storage_bucket.data",
		"type": "google_storage_bucket",
		"mode": "managed",
		"change": {
			"actions": ["create"],
			"after": {"uniform_bucket_level_access": true}
		}
	}]
}

test_insecure_gcp_bucket_denied if {
	violations := analysis.deny with input as mock_plan_insecure_bucket
	count(violations) == 1
	some v in violations
	v.rule_id == "gcp_storage_uniform_access"
}

test_secure_gcp_bucket_allowed if {
	violations := analysis.deny with input as mock_plan_secure_bucket
	count(violations) == 0
}
