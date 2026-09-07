package lib.tags

import rego.v1
import data.lib.tfplan

# Check if resource has tags or labels map
has_tags(resource) if {
	after := tfplan.after_or_empty(resource)
	after.tags != null
}

has_tags(resource) if {
	after := tfplan.after_or_empty(resource)
	after.labels != null
}

# Safely extract tag/label dictionary from a resource
tags_or_labels(resource) := tags if {
	after := tfplan.after_or_empty(resource)
	tags := after.tags
	tags != null
} else := labels if {
	after := tfplan.after_or_empty(resource)
	labels := after.labels
	labels != null
} else := {}

# Find missing tags given a list of required tag keys
missing_tags(resource, required_keys) := [key |
	some key in required_keys
	tags := tags_or_labels(resource)
	not tags[key]
]
