package lib.blast_radius_test

import rego.v1
import data.lib.blast_radius

mock_plan := {
	"resource_changes": [
		{
			"address": "res.del1",
			"mode": "managed",
			"change": {"actions": ["delete"]}
		},
		{
			"address": "res.del2",
			"mode": "managed",
			"change": {"actions": ["delete"]}
		},
		{
			"address": "res.upd1",
			"mode": "managed",
			"change": {"actions": ["update"]}
		},
		{
			"address": "res.cre1",
			"mode": "managed",
			"change": {"actions": ["create"]}
		}
	]
}

test_deleted_count if {
	blast_radius.deleted_count == 2 with input as mock_plan
}

test_score_calculation if {
	# 2 * 5 + 1 * 2 + 1 * 1 = 13
	blast_radius.score == 13 with input as mock_plan
}
