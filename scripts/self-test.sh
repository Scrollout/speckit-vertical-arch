#!/usr/bin/env bash
# Self-test for the vertical-slice preset and the vsa extension.
#
# Installs both into a throwaway Spec-Kit project, checks what Spec-Kit delivers, removes both,
# and checks that nothing is left. Every check that fails is reported, and the script exits
# non-zero when any check fails.
#
# Usage:
#   scripts/self-test.sh
#
# Environment:
#   SPECIFY        Command that runs the Spec-Kit CLI. Default: a pinned uvx run of SPECKIT_REF.
#   SPECKIT_REF    Spec-Kit git tag used by the default SPECIFY. Default: v1.2.5.
#   KEEP_WORKDIR   Set to 1 to keep the throwaway project for inspection.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PRESET_DIR="$REPO_ROOT/presets/vertical-slice"
EXTENSION_DIR="$REPO_ROOT/extensions/vsa"
SPECKIT_REF="${SPECKIT_REF:-v1.2.5}"
SPECIFY="${SPECIFY:-uvx --from git+https://github.com/github/spec-kit.git@${SPECKIT_REF} specify}"

WORKDIR="$(mktemp -d)"
FAILURES=0

cleanup() {
  if [[ "${KEEP_WORKDIR:-0}" == "1" ]]; then
    echo "Kept $WORKDIR"
  else
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT

pass() { echo "  PASS  $1"; }
fail() { echo "  FAIL  $1"; FAILURES=$((FAILURES + 1)); }

# Runs the Spec-Kit CLI inside the throwaway project. Output is kept for checks.
specify_run() {
  (cd "$WORKDIR" && $SPECIFY "$@") >"$WORKDIR/.last-output" 2>&1
}

yaml_version() {
  # First `version:` value under the given top-level key in a manifest.
  awk -v key="$2:" '
    $1 == key { inside = 1; next }
    inside && /^[^ ]/ { inside = 0 }
    inside && $1 == "version:" { gsub(/"/, "", $2); print $2; exit }
  ' "$1"
}

echo "== Manifest consistency"

preset_version="$(yaml_version "$PRESET_DIR/preset.yml" preset)"
extension_version="$(yaml_version "$EXTENSION_DIR/extension.yml" extension)"
preset_minor="${preset_version%.*}"
extension_minor="${extension_version%.*}"

if grep -qF "supports \`>=${preset_minor}.0\` and \`<" "$EXTENSION_DIR/commands/speckit.vsa.check.md"; then
  pass "vsa check supports preset ${preset_minor}.x (preset is $preset_version)"
else
  fail "vsa check's supported preset range does not include preset $preset_version"
fi

if grep -qF "version: \">=${extension_minor}.0," "$PRESET_DIR/preset.yml"; then
  pass "preset's vsa dependency includes extension $extension_version"
else
  fail "preset's requires.extensions range does not include extension $extension_version"
fi

while read -r declared; do
  if [[ -f "$PRESET_DIR/$declared" ]]; then
    pass "declared file exists: $declared"
  else
    fail "declared file missing: $declared"
  fi
done < <(grep -E '^\s+file: ' "$PRESET_DIR/preset.yml" | sed -E 's/.*file: "?([^"]+)"?/\1/')

echo "== No retired structure or names"

# Terms replaced by the current structure and naming rules. Changelogs may still name them.
while IFS= read -r term; do
  status=0
  hits="$(grep -rlF --include='*.md' --exclude='CHANGELOG.md' -e "$term" "$PRESET_DIR" "$EXTENSION_DIR")" || status=$?
  if [[ "$status" -gt 1 ]]; then
    fail "search for retired term failed: $term"
  elif [[ -z "$hits" ]]; then
    pass "retired term absent: $term"
  else
    fail "retired term still used: $term in $(echo "$hits" | tr '\n' ' ')"
  fi
done <<'EOF'
services/[context]
contracts/[version]
[slice-name]
place-order
verb and a noun
http-public
http-internal
[host-name]
Deploys as [context]-[trigger]
EOF

echo "== Fresh project"

(cd "$WORKDIR" && git init -q)
if specify_run init --here --integration claude --script sh --ignore-agent-tools --force --non-interactive; then
  pass "specify init"
else
  fail "specify init"; cat "$WORKDIR/.last-output"; exit 1
fi

echo "== Core text that the overrides take precedence over"

# Each line: phrase<TAB>file inside the fresh project. If core rewords one, the preset's
# precedence statement points at nothing and must be updated.
while IFS=$'\t' read -r phrase file; do
  if grep -qiF -- "$phrase" "$WORKDIR/$file" 2>/dev/null; then
    pass "core still has: $phrase"
  else
    fail "core no longer has: $phrase (in $file)"
  fi
done <<'EOF'
Extract entities from feature spec	.claude/skills/speckit-plan/SKILL.md
Style/wording improvements	.claude/skills/speckit-analyze/SKILL.md
Implement models, services	.claude/skills/speckit-implement/SKILL.md
Core development	.claude/skills/speckit-implement/SKILL.md
→ Models → Services → Endpoints → Integration	.claude/skills/speckit-tasks/SKILL.md
Models needed for that story	.claude/skills/speckit-tasks/SKILL.md
Relationships → service layer	.claude/skills/speckit-tasks/SKILL.md
Shared infrastructure → Setup phase	.claude/skills/speckit-tasks/SKILL.md
src/models/	.claude/skills/speckit-tasks/SKILL.md
Models before services	.specify/templates/tasks-template.md
EOF

echo "== Install preset alone (vsa is optional)"

if specify_run preset add --dev "$PRESET_DIR"; then
  pass "preset add without vsa"
else
  fail "preset add without vsa"; cat "$WORKDIR/.last-output"
fi

echo "== Install extension"

if specify_run extension add --dev "$EXTENSION_DIR"; then
  pass "extension add"
else
  fail "extension add"; cat "$WORKDIR/.last-output"
fi

echo "== Delivered commands"

for pair in plan:plan-rules tasks:tasks-rules analyze:analyze-rules implement:implement-rules; do
  skill="${pair%%:*}"; marker="vertical-slice:${pair#*:}"
  file="$WORKDIR/.claude/skills/speckit-$skill/SKILL.md"
  if grep -qF "$marker" "$file" 2>/dev/null; then
    pass "speckit-$skill has $marker"
  else
    fail "speckit-$skill is missing $marker"
  fi
done

if grep -qF "vertical-slice:check" "$WORKDIR/.claude/skills/speckit-vsa-check/SKILL.md" 2>/dev/null; then
  pass "speckit-vsa-check delivered"
else
  fail "speckit-vsa-check not delivered"
fi

echo "== Template resolution"

check_resolve() {
  local name="$1" expected="$2"
  if specify_run preset resolve "$name" && tr -d '\n' <"$WORKDIR/.last-output" | grep -qF "$expected"; then
    pass "$name resolves with $expected"
  else
    fail "$name does not resolve with $expected"; cat "$WORKDIR/.last-output"
  fi
}
check_resolve plan-template "top layer from: vertical-slice v$preset_version"
check_resolve tasks-template "top layer from: vertical-slice v$preset_version"
check_resolve constitution-template "[append] vertical-slice v$preset_version"
check_resolve speckit.tasks "[prepend] vertical-slice v$preset_version"
check_resolve speckit.implement "[prepend] vertical-slice v$preset_version"
check_resolve speckit.plan "[append] vertical-slice v$preset_version"
check_resolve speckit.analyze "[append] vertical-slice v$preset_version"

echo "== Hooks"

for hook in after_tasks after_implement; do
  if awk -v h="$hook:" '$1 == h { inside = 1; next } inside && /^ ? ?[^ -]/ { inside = 0 } inside && /command: speckit.vsa.check/ { found = 1 } END { exit !found }' "$WORKDIR/.specify/extensions.yml"; then
    pass "$hook runs speckit.vsa.check"
  else
    fail "$hook does not run speckit.vsa.check"
  fi
done

echo "== Removal"

specify_run extension remove vsa --force || fail "extension remove"
specify_run preset remove vertical-slice || fail "preset remove"

leftovers="$(grep -rlF "vertical-slice:" "$WORKDIR/.claude" "$WORKDIR/.specify" 2>/dev/null || true)"
if [[ -z "$leftovers" ]]; then
  pass "no vertical-slice markers left"
else
  fail "markers left after removal:"; echo "$leftovers"
fi

echo
if [[ "$FAILURES" -eq 0 ]]; then
  echo "Self-test passed."
else
  echo "Self-test failed: $FAILURES check(s)."
  exit 1
fi
