package lib.infracost_test

import data.lib.infracost
import rego.v1

sample_infracost := {
	"status": "SUCCESS",
	"currency": "USD",
	"totalMonthlyCost": "350.50",
	"pastTotalMonthlyCost": "100.00",
	"diffTotalMonthlyCost": "250.50",
	"summary": {
		"totalDetectedResources": 4,
		"totalSupportedResources": 3,
		"totalUnsupportedResources": 1,
		"totalNoPriceResources": 0,
	},
	"projects": [{
		"name": "aws-prod",
		"breakdown": {
			"resources": [
				{"name": "aws_instance.app", "resourceType": "aws_instance", "monthlyCost": "280.50"},
				{"name": "aws_ebs_volume.data", "resourceType": "aws_ebs_volume", "monthlyCost": "70.00"},
			],
		},
	}],
}

test_has_cost_data_valid if {
	infracost.has_cost_data with data.infracost as sample_infracost
}

test_has_cost_data_error_status if {
	not infracost.has_cost_data with data.infracost as {"status": "ERROR", "errorMessage": "timeout"}
}

test_cost_totals_parsed if {
	infracost.total_monthly_cost == 350.5 with data.infracost as sample_infracost
	infracost.past_monthly_cost == 100 with data.infracost as sample_infracost
	infracost.diff_monthly_cost == 250.5 with data.infracost as sample_infracost
	infracost.currency == "USD" with data.infracost as sample_infracost
}

test_resources_and_coverage if {
	res := infracost.resources with data.infracost as sample_infracost
	count(res) == 2
	infracost.unsupported_resources_count == 1 with data.infracost as sample_infracost
	infracost.no_price_resources_count == 0 with data.infracost as sample_infracost
}

test_parse_amount_handles_invalid_values if {
	infracost.parse_amount(null) == 0
	infracost.parse_amount("") == 0
	infracost.parse_amount("not-a-number") == 0
	infracost.parse_amount(42.5) == 42.5
}
