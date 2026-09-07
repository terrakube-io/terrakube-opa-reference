package lib.tags_test

import rego.v1
import data.lib.tags

resource_with_tags := {
	"address": "aws_instance.web",
	"change": {
		"actions": ["create"],
		"after": {
			"tags": {
				"Environment": "production",
				"Owner": "devops@terrakube.io"
			}
		}
	}
}

resource_missing_tags := {
	"address": "aws_instance.db",
	"change": {
		"actions": ["create"],
		"after": {
			"tags": {
				"Environment": "staging"
			}
		}
	}
}

test_missing_tags_detected if {
	required := ["Environment", "Owner", "CostCenter"]
	missing := tags.missing_tags(resource_missing_tags, required)
	missing == ["Owner", "CostCenter"]
}

test_all_tags_present if {
	required := ["Environment", "Owner"]
	missing := tags.missing_tags(resource_with_tags, required)
	count(missing) == 0
}
