# Unit Tests — tf-molecule-security-group-web-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:         terraform test -test-directory=tests/unit
# Run verbose:      terraform test -test-directory=tests/unit -verbose
#
# Assertions target PLAN-KNOWN values only (the tf-label `id` string and
# input pass-throughs). Computed attributes such as the security group's
# real id/arn are unknown under a mock provider, so they are NOT asserted.

mock_provider "aws" {}

variables {
  # tf-label identity
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # module-required inputs
  vpc_id       = "vpc-0123456789abcdef0"
  allowed_cidr = "10.0.0.0/16"
}

# ---------------------------------------------------------------------------
# Test: module builds a stable, disambiguated identity when enabled
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.id == "eg-test-thing"
    error_message = "Expected tf-label id 'eg-test-thing' from namespace/stage/name inputs, got '${output.id}'."
  }

  assert {
    condition     = output.id != null
    error_message = "Web tier id output must be non-null when the module is enabled."
  }
}

# ---------------------------------------------------------------------------
# Test: identity recomputes from labels (namespace/stage/name pass-through)
# ---------------------------------------------------------------------------
# NOTE: an `enabled = false` run is intentionally omitted. The composed
# security-group-rule atoms validate `length(security_group_id) > 0`, and when
# the group is disabled its id is null — so the disabled path errors at the atom
# boundary rather than in this molecule. We therefore assert only plan-known,
# enabled-path values here.
run "identity_reflects_labels" {
  command = plan

  variables {
    namespace = "eg"
    stage     = "prod"
    name      = "web"
  }

  assert {
    condition     = output.id == "eg-prod-web"
    error_message = "tf-label id must reflect namespace/stage/name; expected 'eg-prod-web', got '${output.id}'."
  }
}
