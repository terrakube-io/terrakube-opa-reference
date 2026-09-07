package lib.tfplan_test

import rego.v1
import data.lib.tfplan

mock_plan := {
	"resource_changes": [
		{
			"address": "aws_s3_bucket.valid",
			"type": "aws_s3_bucket",
			"mode": "managed",
			"change": {
				"actions": ["create"],
				"after": {"bucket": "my-bucket"}
			}
		},
		{
			"address": "aws_s3_bucket.deleting",
			"type": "aws_s3_bucket",
			"mode": "managed",
			"change": {
				"actions": ["delete"],
				"after": null
			}
		},
		{
			"address": "data.aws_ami.ubuntu",
			"type": "aws_ami",
			"mode": "data",
			"change": {
				"actions": ["read"],
				"after": {"id": "ami-12345"}
			}
		}
	]
}

test_resources_by_type if {
	res := tfplan.resources_by_type("aws_s3_bucket") with input as mock_plan
	count(res) == 2
}

test_is_create_or_update if {
	res := mock_plan.resource_changes[0]
	tfplan.is_create_or_update(res)
}

test_is_delete if {
	res := mock_plan.resource_changes[1]
	tfplan.is_delete(res)
}

test_managed_create_or_update if {
	res := tfplan.managed_create_or_update with input as mock_plan
	count(res) == 1
}
