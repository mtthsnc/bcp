#!/usr/bin/env bash
# BCP Brand Check — the machine half of the conformance loop. Runs locally, in
# pre-commit, and in CI. Enforces the structural contracts so Brand Truth stays
# cited + dated, decisions stay append-only, skills stay valid, and outputs carry
# a trace. The QUALITATIVE half (scoring an output against the brand) is the
# `brand-check` skill, not this script.
# Advisory (only if installed): shellcheck.
# Exit nonzero if any hard gate fails.
set -uo pipefail
cd "$(dirname "$(readlink -f "$0")")/.." || exit 2

fail=0
ok()   { printf '  \033[32m✓\033[0m %s\n' "$*"; }
bad()  { printf '  \033[31m✗\033[0m %s\n' "$*"; fail=1; }
skip() { printf '  \033[33m–\033[0m %s\n' "$*"; }

echo "== shell syntax =="
while IFS= read -r f; do
  if bash -n "$f"; then ok "bash -n $f"; else bad "syntax error: $f"; fi
done < <(find . -name '*.sh' -not -path './.git/*' -not -path './node_modules/*' | sort)

echo "== shellcheck =="
if command -v shellcheck >/dev/null 2>&1; then
  while IFS= read -r f; do
    if shellcheck "$f"; then ok "shellcheck $f"; else bad "shellcheck: $f"; fi
  done < <(find . -name '*.sh' -not -path './.git/*' -not -path './node_modules/*' | sort)
else
  skip "shellcheck not installed"
fi

echo "== config.json =="
if [ -f harness/config.json ] && python3 -c "import json; json.load(open('harness/config.json'))"; then
  ok "harness/config.json is valid JSON"
else
  bad "harness/config.json missing or invalid JSON"
fi

echo "== brand truth contract (cited + dated) =="
if python3 - <<'PY'; then ok "all truths cited and dated"; else bad "brand truth contract failed"; fi
import glob, os, re, sys
bad = 0
# Truth-bearing sections. 00-source (raw) and 09-loops (logs) are exempt; 08-decisions has its own contract.
sections = ["01-imprint","02-voice","03-design","04-lenses","05-architecture","06-assets","07-runtime"]
DATE = re.compile(r"^\d{4}-\d{2}-\d{2}$")
found = 0
for sec in sections:
    for p in sorted(glob.glob(f"harness/brand/{sec}/**/*.md", recursive=True)):
        if os.path.basename(p) == "README.md":
            continue
        found += 1
        raw = open(p, encoding="utf-8").read()
        m = re.match(r"^---\n(.*?)\n---\n", raw, re.DOTALL)
        if not m:
            print(f"    missing frontmatter: {p}"); bad = 1; continue
        fm = m.group(1)
        def get(k):
            mm = re.search(rf"^{k}:\s*(.+)$", fm, re.M)
            return mm.group(1).strip() if mm else None
        if not get("id"):     print(f"    missing 'id': {p}"); bad = 1
        if not get("source"): print(f"    missing 'source' (a truth must be cited): {p}"); bad = 1
        d = get("date")
        if not d:             print(f"    missing 'date': {p}"); bad = 1
        elif not DATE.match(d):print(f"    date not YYYY-MM-DD: {p}"); bad = 1
        st = get("status")
        if st not in ("active","superseded"): print(f"    status must be active|superseded: {p}"); bad = 1
        ty = get("type")
        if ty not in ("truth","refusal"):     print(f"    type must be truth|refusal: {p}"); bad = 1
if found == 0:
    print("    (no truths yet — gate passes on an empty brand)")
sys.exit(bad)
PY

echo "== decisions append-only + dated =="
if python3 - <<'PY'; then ok "decisions valid"; else bad "decision contract failed"; fi
import glob, os, re, sys
bad = 0
DATE = re.compile(r"^\d{4}-\d{2}-\d{2}$")
for p in sorted(glob.glob("harness/brand/08-decisions/**/*.md", recursive=True)):
    if os.path.basename(p) == "README.md":
        continue
    raw = open(p, encoding="utf-8").read()
    m = re.match(r"^---\n(.*?)\n---\n", raw, re.DOTALL)
    if not m:
        print(f"    missing frontmatter: {p}"); bad = 1; continue
    fm = m.group(1)
    did = re.search(r"^id:\s*(.+)$", fm, re.M)
    dt  = re.search(r"^date:\s*(.+)$", fm, re.M)
    stt = re.search(r"^status:\s*(.+)$", fm, re.M)
    if not did: print(f"    decision missing 'id': {p}"); bad = 1
    if not dt or not DATE.match(dt.group(1).strip()): print(f"    decision missing/!ISO 'date': {p}"); bad = 1
    if not stt or stt.group(1).strip() not in ("accepted","superseded"):
        print(f"    decision status must be accepted|superseded: {p}"); bad = 1
sys.exit(bad)
PY

echo "== skill contract =="
if python3 - <<'PY'; then ok "all skills valid"; else bad "skill contract failed"; fi
import glob, os, re, sys
bad = 0
skills = sorted(glob.glob("harness/skills/*/SKILL.md"))
if not skills:
    print("    (no skills yet)")
for p in skills:
    parent = os.path.basename(os.path.dirname(p))
    raw = open(p, encoding="utf-8").read()
    m = re.match(r"^---\n(.*?)\n---\n", raw, re.DOTALL)
    if not m:
        print(f"    missing frontmatter: {p}"); bad = 1; continue
    if len(m.group(0)) > 1024:
        print(f"    frontmatter > 1024 chars: {p}"); bad = 1
    fm = m.group(1)
    name = re.search(r"^name:\s*(.+)$", fm, re.M)
    desc = re.search(r"^description:\s*(.+)$", fm, re.M)
    if not name:
        print(f"    missing 'name': {p}"); bad = 1
    else:
        n = name.group(1).strip()
        if not re.match(r"^[a-z0-9]+(-[a-z0-9]+)*$", n) or len(n) > 64:
            print(f"    invalid name (lowercase/numbers/hyphens, <=64): {p}"); bad = 1
        elif n != parent:
            print(f"    name '{n}' must match directory '{parent}': {p}"); bad = 1
    if not desc:
        print(f"    missing 'description': {p}"); bad = 1
    elif not desc.group(1).strip().lower().startswith("use when"):
        print(f"    description must start with 'Use when': {p}"); bad = 1
sys.exit(bad)
PY

echo "== output traces =="
if python3 - <<'PY'; then ok "outputs carry a trace"; else bad "output trace contract failed"; fi
import glob, os, re, sys
bad = 0
checked = 0
for d in sorted(glob.glob("harness/output/*/")):
    files = [f for f in glob.glob(os.path.join(d, "**", "*"), recursive=True) if os.path.isfile(f)]
    if not files:
        continue
    checked += 1
    trace = os.path.join(d, "trace.md")
    src = None
    if os.path.isfile(trace):
        raw = open(trace, encoding="utf-8").read()
        m = re.match(r"^---\n(.*?)\n---\n", raw, re.DOTALL)
        src = m.group(1) if m else None
    else:
        # allow a trace as frontmatter on any file in the dir
        for f in files:
            if not f.endswith(".md"): continue
            m = re.match(r"^---\n(.*?)\n---\n", open(f, encoding="utf-8").read(), re.DOTALL)
            if m and "produced_by:" in m.group(1):
                src = m.group(1); break
    if not src:
        print(f"    output has no trace (need trace.md or produced_by frontmatter): {d}"); bad = 1; continue
    for key in ("produced_by", "date", "sources"):
        if not re.search(rf"^{key}:", src, re.M):
            print(f"    trace missing '{key}': {d}"); bad = 1
if checked == 0:
    print("    (no deliverables yet — nothing to trace)")
sys.exit(bad)
PY

echo "== no hardcoded home paths =="
hits="$(grep -RnE '(/home/|/Users/)[A-Za-z0-9]' \
  --exclude-dir=.git --exclude-dir=node_modules \
  --include='*.sh' --include='*.md' --include='*.json' --include='*.yaml' --include='*.yml' . \
  | grep -v '\.git/' || true)"
if [ -n "$hits" ]; then
  bad "hardcoded home paths found:"
  printf '%s\n' "$hits" | sed 's/^/      /'
else
  ok "no hardcoded home/user paths in tracked files"
fi

echo
if [ "$fail" -ne 0 ]; then
  echo "BRAND CHECK: FAIL"
  exit 1
fi
echo "BRAND CHECK: PASS"
