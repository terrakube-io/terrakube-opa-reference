package terraform.analysis_test

import data.terraform.analysis
import rego.v1

mock_high_resource_cost := {
	"status": "SUCCESS",
	"currency": "USD",
	"totalMonthlyCost": "155.00",
	"summary": {
		"totalUnsupportedResources": 0,
		"totalNoPriceResources": 0,
	},
	"projects": [{
		"name": "advisory",
		"breakdown": {
			"resources": [
				{"name": "aws_instance.app", "monthlyCost": "140.00"},
				{"name": "aws_ebs_volume.small", "monthlyCost": "15.00"},
			],
		},
	}],
}

mock_unpriced_resources := {
	"status": "SUCCESS",
	"currency": "USD",
	"totalMonthlyCost": "15.00",
	"summary": {
		"totalUnsupportedResources": 1,
		"totalNoPriceResources": 2,
	},
	"projects": [{
		"name": "partial",
		"breakdown": {
			"resources": [{"name": "aws_instance.tiny", "monthlyCost": "15.00"}],
		},
	}],
}

test_warns_on_expensive_resource if {
	violations := analysis.warn with input as {} with data.infracost as mock_high_resource_cost
	high_cost := [v | some v in violations; v.rule_id == "finops_high_cost_resource"]
	count(high_cost) == 1
	some v in high_cost
	v.resource == "aws_instance.app"
}

test_warns_on_unpriced_resources if {
	violations := analysis.warn with input as {} with data.infracost as mock_unpriced_resources
	unpriced := [v | some v in violations; v.rule_id == "finops_unpriced_resources"]
	count(unpriced) == 1
}

test_passes_cleanly_on_error_payload if {
	violations := analysis.warn with input as {} with data.infracost as {"status": "ERROR"}
	count(violations) == 0
}
