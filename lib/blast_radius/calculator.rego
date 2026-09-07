package lib.blast_radius

import rego.v1
import data.lib.tfplan

# Count total resources being deleted
deleted_count := count([res |
	some res in input.resource_changes
	res.mode == "managed"
	tfplan.is_delete(res)
])

# Count total resources being created
created_count := count([res |
	some res in input.resource_changes
	res.mode == "managed"
	"create" in res.change.actions
])

# Count total resources being updated
updated_count := count([res |
	some res in input.resource_changes
	res.mode == "managed"
	"update" in res.change.actions
])

# Weighted blast radius score: Deletions * 5 + Updates * 2 + Creations * 1
score := (deleted_count * 5) + (updated_count * 2) + (created_count * 1)
