package terraform.analysis

import rego.v1
import data.lib.tfplan

# Rule 1: S3 Bucket Public Access Block must be fully enabled
deny contains violation if {
	some res in tfplan.resources_by_type("aws_s3_bucket_public_access_block")
	tfplan.is_create_or_update(res)
	after := tfplan.after_or_empty(res)

	is_public_access_allowed(after)
	violation := {
		"rule_id": "aws_s3_public_access_block",
		"resource": res.address,
		"message": "S3 Public Access Block must enable block_public_acls, block_public_policy, ignore_public_acls, and restrict_public_buckets.",
	}
}

is_public_access_allowed(after) if {
	after.block_public_acls == false
}

is_public_access_allowed(after) if {
	after.block_public_policy == false
}

is_public_access_allowed(after) if {
	after.ignore_public_acls == false
}

is_public_access_allowed(after) if {
	after.restrict_public_buckets == false
}

# Rule 2: EBS Volumes must have server-side encryption enabled
deny contains violation if {
	some res in tfplan.resources_by_type("aws_ebs_volume")
	tfplan.is_create_or_update(res)
	after := tfplan.after_or_empty(res)
	after.encrypted != true
	violation := {
		"rule_id": "aws_ebs_encryption_required",
		"resource": res.address,
		"message": "AWS EBS Volumes must have server-side encryption enabled (encrypted = true).",
	}
}

# Rule 3: EC2 Instances must require IMDSv2 (http_tokens = "required")
deny contains violation if {
	some res in tfplan.resources_by_type("aws_instance")
	tfplan.is_create_or_update(res)
	after := tfplan.after_or_empty(res)
	meta := after.metadata_options
	not is_imdsv2_enforced(meta)
	violation := {
		"rule_id": "aws_ec2_imdsv2_enforced",
		"resource": res.address,
		"message": "AWS EC2 instances must enforce IMDSv2 with metadata_options.http_tokens = 'required'.",
	}
}

is_imdsv2_enforced(meta) if {
	meta != null
	meta[0].http_tokens == "required"
}

is_imdsv2_enforced(meta) if {
	meta != null
	is_object(meta)
	meta.http_tokens == "required"
}
