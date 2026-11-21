package terraform.analysis_test

import data.terraform.analysis
import rego.v1

test_soft_mandatory_triggers_when_delta_exceeds_limit if {
	violations := analysis.soft_mandatory with input as {} with data.infracost as {
		"status": "SUCCESS",
		"currency": "USD",
		"diffTotalMonthlyCost": "350.00",
	}
	soft_violations := [v | some v in violations; v.rule_id == "finops_monthly_delta_soft_limit"]
	count(soft_violations) == 1
}

test_soft_mandatory_passes_when_within_limit if {
	violations := analysis.soft_mandatory with input as {} with data.infracost as {
		"status": "SUCCESS",
		"currency": "USD",
		"diffTotalMonthlyCost": "150.00",
	}
	soft_violations := [v | some v in violations; v.rule_id == "finops_monthly_delta_soft_limit"]
	count(soft_violations) == 0
}

test_soft_mandatory_ignored_on_infracost_error if {
	violations := analysis.soft_mandatory with input as {} with data.infracost as {
		"status": "ERROR",
		"errorMessage": "API unavailable",
	}
	soft_violations := [v | some v in violations; v.rule_id == "finops_monthly_delta_soft_limit"]
	count(soft_violations) == 0
}
