package terraform.analysis

import rego.v1
import data.lib.blast_radius

default max_deletions := 5
default max_score := 25

# Allow dynamic thresholds from Terrakube policy inputs
configured_max_deletions := to_number(data.terrakube.inputs.max_deletions) if {
	data.terrakube.inputs.max_deletions != ""
} else := max_deletions

configured_max_score := to_number(data.terrakube.inputs.max_score) if {
	data.terrakube.inputs.max_score != ""
} else := max_score

# Soft mandatory rule: triggers when deletions exceed safe threshold
soft_mandatory contains violation if {
	blast_radius.deleted_count > configured_max_deletions
	violation := {
		"rule_id": "common_blast_radius_deletions",
		"resource": "terraform_plan",
		"message": sprintf("Plan deletes %d resources (threshold is %d). Requires SecOps override approval.", [blast_radius.deleted_count, configured_max_deletions]),
	}
}

# Soft mandatory rule: triggers when weighted blast radius score exceeds threshold
soft_mandatory contains violation if {
	blast_radius.score > configured_max_score
	violation := {
		"rule_id": "common_blast_radius_score",
		"resource": "terraform_plan",
		"message": sprintf("Plan blast radius score is %d (threshold is %d). Requires SecOps override approval.", [blast_radius.score, configured_max_score]),
	}
}
