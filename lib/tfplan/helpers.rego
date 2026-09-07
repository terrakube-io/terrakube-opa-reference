package lib.tfplan

import rego.v1

# Extract all resource changes matching a specific resource type
resources_by_type(type_name) := [res |
	some res in input.resource_changes
	res.type == type_name
]

# Check if a resource is being created or updated
is_create_or_update(resource) if {
	some action in resource.change.actions
	action in ["create", "update"]
}

# Check if a resource is being deleted
is_delete(resource) if {
	"delete" in resource.change.actions
}

# Safely extract after values for created or updated resources
after_or_empty(resource) := val if {
	val := resource.change.after
	val != null
} else := {}

# Return all managed resources being created or updated
managed_create_or_update := [res |
	some res in input.resource_changes
	res.mode == "managed"
	is_create_or_update(res)
]
