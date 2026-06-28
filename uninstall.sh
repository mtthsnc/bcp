#!/usr/bin/env bash
# BCP — uninstaller. Removes the skill symlinks this repo created in the harness
# discovery dirs. Only removes links that resolve back into this repo's
# harness/skills, so it is safe alongside other tools.
#
# Usage: ./uninstall.sh
set -euo pipefail

REPO="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
SKILLS_SRC="$REPO/harness/skills"
DEST="${BCP_DEST:-$REPO}"

say() { printf '  %s\n' "$*"; }

unlink_from() {
  local dest="$1"
  [ -d "$dest" ] || return 0
  for s in "$SKILLS_SRC"/*/; do
    [ -d "$s" ] || continue
    local name link; name="$(basename "$s")"; link="$dest/$name"
    if [ -L "$link" ] && [ "$(readlink -f "$link")" = "$(readlink -f "${s%/}")" ]; then
      rm -f "$link"; say "removed $dest/$name"
    fi
  done
  rmdir "$dest" 2>/dev/null || true
}

unlink_from "$DEST/.claude/skills"
unlink_from "$DEST/.pi/skills"
echo "BCP: uninstalled."
