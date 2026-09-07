# Contributing Policy Rules to Terrakube OPA Reference

This guide explains how to write, test, and package Open Policy Agent (Rego) rules compatible with Terrakube's runtime evaluation engine.

---

## 1. Engine Compatibility & Contract

Terrakube's Executor executes OPA CLI against `plan.json` using the following invocation:
```bash
opa eval --data <policyBundleDir> --input plan.json --format json "data.terraform.analysis"
```

To integrate with Terrakube, every bundle must be declared under:
```rego
package terraform.analysis
```

Terrakube inspects the following collections under `data.terraform.analysis`:

| Output Rule | Severity / Enforcement | Terrakube Job Behavior |
| :--- | :--- | :--- |
| `deny` | **Hard Mandatory** | Fails the job immediately (`exitCode = 1`), blocking `terraform apply`. |
| `soft_mandatory` | **Soft Mandatory** | Flags the run and moves job to `WAITING_APPROVAL`, requiring a SecOps override. |
| `warn` | **Advisory** | Outputs ANSI-formatted warning messages in the job console; does not block. |

---

## 2. Violation Object Structure

Violations must be emitted as structured dictionaries with `rule_id`, `resource`, and `message`:

```rego
deny contains violation if {
    some res in tfplan.resources_by_type("aws_s3_bucket")
    # your condition here
    violation := {
        "rule_id": "aws_s3_encryption_required",
        "resource": res.address,
        "message": "AWS S3 buckets must have server-side encryption enabled."
    }
}
```

> [!TIP]
> Emitting a unique `rule_id` is essential because Terrakube matches policy exemptions against `rule_id`. When an active exemption is matched, Terrakube automatically removes the violation from blocking criteria.

---

## 3. Using Shared Helper Libraries (`lib/`)

Always reuse functions from `lib/` rather than writing ad-hoc JSON traversals:

* `lib.tfplan`:
  * `tfplan.resources_by_type("res_type")`: Extracts resource changes matching the type.
  * `tfplan.is_create_or_update(res)`: Returns true if action includes create or update.
  * `tfplan.is_delete(res)`: Returns true if action includes delete.
  * `tfplan.after_or_empty(res)`: Safely returns `change.after` or empty dict.
  * `tfplan.managed_create_or_update`: All managed resources being created/updated.
* `lib.tags`:
  * `tags.missing_tags(res, required_keys)`: Identifies missing tags.
* `lib.blast_radius`:
  * `blast_radius.deleted_count`: Total deleted resources.
  * `blast_radius.score`: Weighted blast radius score.
* `lib.networking`:
  * `networking.is_open_to_internet(cidr)`: Checks for `0.0.0.0/0` or `::/0`.
  * `networking.is_sensitive_port(port)`: Checks for port 22 or 3389.

---

## 4. Local Testing & Quality Gates

Every policy bundle must have a corresponding `rules_test.rego` unit test:

```bash
# Run all unit tests
opa test lib/ bundles/ -v

# Run Regal linter
regal lint lib/ bundles/
```
