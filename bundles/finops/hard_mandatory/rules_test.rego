package terraform.analysis_test

import data.terraform.analysis
import rego.v1

test_hard_mandatory_blocks_over_ceiling if {
	violations := analysis.deny with input as {} with data.infracost as {
		"status": "SUCCESS",
		"currency": "USD",
		"totalMonthlyCost": "5606.40",
	}
	hard_violations := [v | some v in violations; v.rule_id == "finops_monthly_budget_hard_ceiling"]
	count(hard_violations) == 1
}

test_hard_mandatory_allows_within_ceiling if {
	violations := analysis.deny with input as {} with data.infracost as {
		"status": "SUCCESS",
		"currency": "USD",
		"totalMonthlyCost": "4999.99",
	}
	hard_violations := [v | some v in violations; v.rule_id == "finops_monthly_budget_hard_ceiling"]
	count(hard_violations) == 0
}
