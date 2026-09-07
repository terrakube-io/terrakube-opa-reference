package terraform.analysis_test

import rego.v1
import data.terraform.analysis

mock_plan_missing_tags := {
	"resource_changes": [{
		"address": "aws_s3_bucket.data",
		"type": "aws_s3_bucket",
		"mode": "managed",
		"change": {
			"actions": ["create"],
			"after": {
				"tags": {"Environment": "dev"}
			}
		}
	}]
}

mock_plan_all_tags := {
	"resource_changes": [{
		"address": "aws_s3_bucket.data",
		"type": "aws_s3_bucket",
		"mode": "managed",
		"change": {
			"actions": ["create"],
			"after": {
				"tags": {
					"Environment": "dev",
					"Owner": "platform-team@terrakube.io",
					"CostCenter": "CC-102"
				}
			}
		}
	}]
}

test_tagging_warns_when_missing if {
	v := analysis.warn with input as mock_plan_missing_tags
	count(v) == 1
	some item in v
	item.rule_id == "common_mandatory_tagging"
}

test_tagging_passes_when_present if {
	v := analysis.warn with input as mock_plan_all_tags
	count(v) == 0
}
