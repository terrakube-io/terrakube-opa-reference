package terraform.analysis_test

import data.terraform.analysis
import rego.v1

test_dynamic_budget_uses_default_500 if {
	violations := analysis.deny with input as {} with data.infracost as {
		"status": "SUCCESS",
		"currency": "USD",
		"totalMonthlyCost": "140.00",
	}
	dynamic_violations := [v | some v in violations; v.rule_id == "finops_dynamic_monthly_budget"]
	count(dynamic_violations) == 0
}

test_dynamic_budget_denies_with_string_parameter if {
	violations := analysis.deny
		with input as {}
		with data.infracost as {"status": "SUCCESS", "currency": "USD", "totalMonthlyCost": "140.00"}
		with data.terrakube.inputs as {"max_monthly_cost": "100"}
	dynamic_violations := [v | some v in violations; v.rule_id == "finops_dynamic_monthly_budget"]
	count(dynamic_violations) == 1
}

test_dynamic_budget_denies_with_numeric_parameter if {
	violations := analysis.deny
		with input as {}
		with data.infracost as {"status": "SUCCESS", "currency": "USD", "totalMonthlyCost": "140.00"}
		with data.terrakube.inputs as {"max_monthly_cost": 100}
	dynamic_violations := [v | some v in violations; v.rule_id == "finops_dynamic_monthly_budget"]
	count(dynamic_violations) == 1
}
