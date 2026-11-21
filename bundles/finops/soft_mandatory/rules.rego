package terraform.analysis

import data.lib.infracost
import rego.v1

default default_soft_delta_limit := 200

configured_soft_delta_limit := to_number(data.terrakube.inputs.max_monthly_delta) if {
	data.terrakube.inputs.max_monthly_delta != ""
} else := default_soft_delta_limit

# Soft mandatory rule: Pause for FinOps approval when estimated monthly increase exceeds threshold
soft_mandatory contains violation if {
	infracost.has_cost_data
	infracost.diff_monthly_cost > configured_soft_delta_limit
	violation := {
		"rule_id": "finops_monthly_delta_soft_limit",
		"resource": "infracost_plan",
		"message": sprintf(
			"Estimated monthly cost increase (+%v %s) exceeds FinOps soft limit (%v %s). Approval required.",
			[infracost.diff_monthly_cost, infracost.currency, configured_soft_delta_limit, infracost.currency],
		),
	}
}
