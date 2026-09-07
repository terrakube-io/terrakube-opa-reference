package terraform.analysis_test

import rego.v1
import data.terraform.analysis

mock_plan_unencrypted_ebs := {
	"resource_changes": [{
		"address": "aws_ebs_volume.db_vol",
		"type": "aws_ebs_volume",
		"mode": "managed",
		"change": {
			"actions": ["create"],
			"after": {"encrypted": false, "size": 50}
		}
	}]
}

mock_plan_encrypted_ebs := {
	"resource_changes": [{
		"address": "aws_ebs_volume.db_vol",
		"type": "aws_ebs_volume",
		"mode": "managed",
		"change": {
			"actions": ["create"],
			"after": {"encrypted": true, "size": 50}
		}
	}]
}

test_ebs_unencrypted_denied if {
	violations := analysis.deny with input as mock_plan_unencrypted_ebs
	count(violations) == 1
	some v in violations
	v.rule_id == "aws_ebs_encryption_required"
}

test_ebs_encrypted_passed if {
	violations := analysis.deny with input as mock_plan_encrypted_ebs
	count(violations) == 0
}
