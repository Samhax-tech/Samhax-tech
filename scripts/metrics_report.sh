#!/usr/bin/env bash
# Quick repo metrics script. Run from repo root.
# Requires: git, cloc (optional), gh (optional)
set -euo pipefail

echo "Repository metrics report"
echo "========================="
echo "Repository: $(basename $(git rev-parse --show-toplevel))"
echo "Current branch: $(git rev-parse --abbrev-ref HEAD)"
echo "Last commit: $(git log -1 --pretty='%h %ad %an' --date=iso)"

echo
echo "Commits and contributors"
echo "------------------------"
echo "Total commits: $(git rev-list --count HEAD)"
echo "Unique contributors: $(git shortlog -sn | wc -l)"
git shortlog -sn | head -n 20

echo
echo "Files & LOC (if cloc available)"
echo "-------------------------------"
if command -v cloc >/dev/null 2>&1; then
  cloc --by-file --quiet . | tee cloc-by-file.txt
  cloc --quiet . || true
else
  echo "Install cloc (https://github.com/AlDanial/cloc) to get language/LOC breakdown"
  echo "Total files: $(git ls-files | wc -l)"
fi

echo
echo "Open issues / PRs via gh (if available)"
echo "---------------------------------------"
if command -v gh >/dev/null 2>&1; then
  echo "Open issues:"
  gh issue list --limit 50 --state open || true
  echo
  echo "Open PRs:"
  gh pr list --limit 50 --state open || true
else
  echo "Install GitHub CLI (gh) to list issues and PRs"
fi
