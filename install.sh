#!/usr/bin/env bash
# BCP — installer. Wires this brand repo's skills into the agent harnesses so pi
# and Claude Code discover them when you work in this repo. Project-scoped on
# purpose: brand skills belong to THIS brand, not your whole machine.
# Idempotent: safe to re-run after `git pull`.
#
# It symlinks each harness/skills/<name> into:
#   <repo>/.claude/skills/<name>   (Claude Code project skills)
#   <repo>/.pi/skills/<name>       (pi project skills — load after you trust the project)
# Both harnesses read this repo's AGENTS.md / CLAUDE.md automatically.
#
# Usage:
#   ./install.sh                 # wire both harnesses
#   ./install.sh --no-claude     # skip Claude
#   ./install.sh --no-pi         # skip pi
#
# Advanced: set BCP_DEST to wire the .claude/.pi dirs somewhere other than the repo root.
set -euo pipefail

REPO="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
SKILLS_SRC="$REPO/harness/skills"
DEST="${BCP_DEST:-$REPO}"

WANT_CLAUDE=1; WANT_PI=1
for arg in "$@"; do
  case "$arg" in
    --no-claude) WANT_CLAUDE=0 ;;
    --no-pi) WANT_PI=0 ;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown arg: $arg" >&2; exit 2 ;;
  esac
done

say() { printf '  %s\n' "$*"; }
echo "BCP: wiring skills from $SKILLS_SRC"

link_into() {
  local dest="$1"; mkdir -p "$dest"
  [ -d "$SKILLS_SRC" ] || return 0
  for s in "$SKILLS_SRC"/*/; do
    [ -d "$s" ] || continue
    local name link; name="$(basename "$s")"; link="$dest/$name"
    if [ -L "$link" ]; then rm -f "$link"
    elif [ -e "$link" ]; then mv "$link" "$link.pre-bcp.bak"; say "backed up $name -> $name.pre-bcp.bak"; fi
    ln -sfn "${s%/}" "$link"
  done
}

if [ "$WANT_CLAUDE" -eq 1 ]; then
  link_into "$DEST/.claude/skills"; say "linked skills -> $DEST/.claude/skills (Claude Code)"
else say "skipped Claude (--no-claude)"; fi

if [ "$WANT_PI" -eq 1 ]; then
  link_into "$DEST/.pi/skills"; say "linked skills -> $DEST/.pi/skills (pi — trust this project to load them)"
else say "skipped pi (--no-pi)"; fi

echo "BCP: done."
echo "  Run your agent from this repo root; it reads AGENTS.md/CLAUDE.md and the wired skills."
echo "  Set your brand name in harness/config.json, then drive the brand-truth skill to begin."
exit 0
