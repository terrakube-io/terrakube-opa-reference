package terraform.analysis_test

import rego.v1
import data.terraform.analysis

mock_plan_insecure_storage := {
	"resource_changes": [{
		"address": "azurerm_storage_account.blob",
		"type": "azurerm_storage_account",
		"mode": "managed",
		"change": {
			"actions": ["create"],
			"after": {
				"enable_https_traffic_only": false,
				"min_tls_version": "TLS1_0"
			}
		}
	}]
}

mock_plan_secure_storage := {
	"resource_changes": [{
		"address": "azurerm_storage_account.blob",
		"type": "azurerm_storage_account",
		"mode": "managed",
		"change": {
			"actions": ["create"],
			"after": {
				"enable_https_traffic_only": true,
				"min_tls_version": "TLS1_2"
			}
		}
	}]
}

test_insecure_storage_denied if {
	violations := analysis.deny with input as mock_plan_insecure_storage
	count(violations) == 1
	some v in violations
	v.rule_id == "azure_storage_secure_transfer"
}

test_secure_storage_allowed if {
	violations := analysis.deny with input as mock_plan_secure_storage
	count(violations) == 0
}
