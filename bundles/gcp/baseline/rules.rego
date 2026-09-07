package terraform.analysis

import rego.v1
import data.lib.tfplan

# Rule 1: GCP Storage Buckets must have uniform bucket-level access enabled
deny contains violation if {
	some res in tfplan.resources_by_type("google_storage_bucket")
	tfplan.is_create_or_update(res)
	after := tfplan.after_or_empty(res)

	after.uniform_bucket_level_access != true
	violation := {
		"rule_id": "gcp_storage_uniform_access",
		"resource": res.address,
		"message": "GCP Storage Buckets must enable uniform bucket-level access (uniform_bucket_level_access = true).",
	}
}

# Rule 2: GCP Compute Instances must not have public external IP addresses assigned
deny contains violation if {
	some res in tfplan.resources_by_type("google_compute_instance")
	tfplan.is_create_or_update(res)
	after := tfplan.after_or_empty(res)

	some iface in after.network_interface
	count(iface.access_config) > 0

	violation := {
		"rule_id": "gcp_compute_no_public_ip",
		"resource": res.address,
		"message": "GCP Compute Instances must not have public external IP addresses (access_config must be omitted).",
	}
}
