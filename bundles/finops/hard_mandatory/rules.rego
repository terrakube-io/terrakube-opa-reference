package terraform.analysis

import data.lib.infracost
import rego.v1

default default_hard_budget_ceiling := 5000

configured_hard_budget_ceiling := to_number(data.terrakube.inputs.hard_monthly_budget) if {
	data.terrakube.inputs.hard_monthly_budget != ""
} else := default_hard_budget_ceiling

# Hard mandatory rule: Strictly block apply when estimated total monthly cost exceeds budget ceiling
deny contains violation if {
	infracost.has_cost_data
	infracost.total_monthly_cost > configured_hard_budget_ceiling
	violation := {
		"rule_id": "finops_monthly_budget_hard_ceiling",
		"resource": "infracost_plan",
		"message": sprintf(
			"Estimated total monthly cost (%v %s) exceeds hard budget ceiling (%v %s). Apply is blocked.",
			[infracost.total_monthly_cost, infracost.currency, configured_hard_budget_ceiling, infracost.currency],
		),
	}
}
