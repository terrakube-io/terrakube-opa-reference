package terraform.analysis

import data.lib.infracost
import rego.v1

default max_resource_monthly_cost := 100

configured_max_resource_cost := to_number(data.terrakube.inputs.max_resource_monthly_cost) if {
	data.terrakube.inputs.max_resource_monthly_cost != ""
} else := max_resource_monthly_cost

# Advisory rule: Warn when any individual resource exceeds the per-resource monthly threshold
warn contains violation if {
	some res in infracost.resources
	cost := infracost.resource_monthly_cost(res)
	cost > configured_max_resource_cost
	violation := {
		"rule_id": "finops_high_cost_resource",
		"resource": res.name,
		"message": sprintf(
			"Estimated monthly cost for '%s' (%v %s) exceeds advisory threshold (%v %s).",
			[res.name, cost, infracost.currency, configured_max_resource_cost, infracost.currency],
		),
	}
}

# Advisory rule: Surface unpriced or unsupported resources for visibility
warn contains violation if {
	unpriced := infracost.unsupported_resources_count + infracost.no_price_resources_count
	unpriced > 0
	violation := {
		"rule_id": "finops_unpriced_resources",
		"resource": "infracost_summary",
		"message": sprintf(
			"Infracost could not price %d resource(s) (%d unsupported, %d no-price); total estimate may be incomplete.",
			[unpriced, infracost.unsupported_resources_count, infracost.no_price_resources_count],
		),
	}
}
