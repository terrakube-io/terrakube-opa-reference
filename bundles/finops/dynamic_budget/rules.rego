package terraform.analysis

import data.lib.infracost
import rego.v1

default default_max_monthly_cost := 500

configured_max_monthly_cost := to_number(data.terrakube.inputs.max_monthly_cost) if {
	data.terrakube.inputs.max_monthly_cost != ""
} else := default_max_monthly_cost

# Hard mandatory rule: Enforce workspace/policy-set dynamic budget limit via PolicySetParameter
deny contains violation if {
	infracost.has_cost_data
	infracost.total_monthly_cost > configured_max_monthly_cost
	violation := {
		"rule_id": "finops_dynamic_monthly_budget",
		"resource": "infracost_plan",
		"message": sprintf(
			"Estimated total monthly cost (%v %s) exceeds configured budget (%v %s). Apply is blocked.",
			[infracost.total_monthly_cost, infracost.currency, configured_max_monthly_cost, infracost.currency],
		),
	}
}
