#!/usr/bin/env bash
# BCP test suite. Wires skills into a throwaway dest and asserts the install
# topology + that the brand-check gate passes on the shipped template.
# No network, no agent CLIs needed. Exit nonzero on any failed assertion.
set -uo pipefail
REPO="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

fail=0
ok()  { printf '  \033[32m✓\033[0m %s\n' "$*"; }
bad() { printf '  \033[31m✗\033[0m %s\n' "$*"; fail=1; }

echo "== brand-check gate passes on the shipped template =="
( cd "$REPO" && ./scripts/brand-check.sh >/dev/null 2>&1 ) && ok "brand-check PASS" || bad "brand-check failed on template"

echo "== install wires skills into both harness dirs =="
BCP_DEST="$TMP" bash "$REPO/install.sh" >/dev/null 2>&1 || bad "install.sh exited nonzero"
for name in brand-truth landing-page brand-check; do
  [ -L "$TMP/.claude/skills/$name" ] && ok "claude/skills/$name linked" || bad "$name not wired into Claude"
  [ -L "$TMP/.pi/skills/$name" ]     && ok "pi/skills/$name linked"     || bad "$name not wired into pi"
  [ -f "$TMP/.claude/skills/$name/SKILL.md" ] && ok "$name/SKILL.md resolves" || bad "$name/SKILL.md does not resolve"
done

echo "== idempotent re-install =="
BCP_DEST="$TMP" bash "$REPO/install.sh" >/dev/null 2>&1 || bad "re-install exited nonzero"
n=$(find "$TMP/.claude/skills" -maxdepth 1 -type l | wc -l | tr -d ' ')
[ "$n" -ge 3 ] && ok "skills present after re-run (no breakage)" || bad "skills missing after re-run (count=$n)"

echo "== every brand section has a README =="
for sec in 00-source 01-imprint 02-voice 03-design 04-lenses 05-architecture 06-assets 07-runtime 08-decisions 09-loops; do
  [ -f "$REPO/harness/brand/$sec/README.md" ] && ok "$sec/README.md" || bad "$sec missing README"
done

echo "== uninstall removes our wiring =="
BCP_DEST="$TMP" bash "$REPO/uninstall.sh" >/dev/null 2>&1 || bad "uninstall.sh exited nonzero"
[ ! -e "$TMP/.claude/skills/brand-truth" ] && ok "claude link removed" || bad "claude link not removed"
[ ! -e "$TMP/.pi/skills/brand-truth" ]     && ok "pi link removed"     || bad "pi link not removed"

echo
if [ "$fail" -ne 0 ]; then
  echo "TESTS: FAIL"
  exit 1
fi
echo "TESTS: PASS"
