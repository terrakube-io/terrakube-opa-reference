package lib.infracost

import rego.v1

# True when valid Infracost estimation data is present
has_cost_data if {
	data.infracost
	object.get(data.infracost, "status", "SUCCESS") != "ERROR"
}

# Safely parse numeric or string cost amounts; defaults to 0
parse_amount(val) := num if {
	is_number(val)
	num := val
} else := num if {
	is_string(val)
	regex.match(`^-?[0-9]+(?:\.[0-9]+)?$`, trim_space(val))
	num := to_number(trim_space(val))
} else := 0

# Aggregate monthly cost across the plan
total_monthly_cost := parse_amount(object.get(data.infracost, "totalMonthlyCost", 0)) if {
	has_cost_data
} else := 0

# Baseline monthly cost before changes
past_monthly_cost := parse_amount(object.get(data.infracost, "pastTotalMonthlyCost", 0)) if {
	has_cost_data
} else := 0

# Projected monthly cost delta
diff_monthly_cost := parse_amount(object.get(data.infracost, "diffTotalMonthlyCost", 0)) if {
	has_cost_data
} else := 0

# Currency ISO code
currency := object.get(data.infracost, "currency", "USD") if {
	has_cost_data
} else := "USD"

# Flattened breakdown resources across all Infracost projects
resources := [res |
	has_cost_data
	some project in object.get(data.infracost, "projects", [])
	breakdown := object.get(project, "breakdown", {})
	some res in object.get(breakdown, "resources", [])
]

resource_monthly_cost(res) := parse_amount(object.get(res, "monthlyCost", 0))

unsupported_resources_count := parse_amount(object.get(summary, "totalUnsupportedResources", 0)) if {
	has_cost_data
	summary := object.get(data.infracost, "summary", {})
} else := 0

no_price_resources_count := parse_amount(object.get(summary, "totalNoPriceResources", 0)) if {
	has_cost_data
	summary := object.get(data.infracost, "summary", {})
} else := 0
