#!/usr/bin/env bash
set -euo pipefail

# Cleanup function to restore state on exit
STASH_CREATED=false
ORIGINAL_BRANCH=""
SWITCHED_BRANCH=false

cleanup() {
  local exit_code=$?

  # Return to original branch if we switched away
  if [ "$SWITCHED_BRANCH" = true ] && [ -n "$ORIGINAL_BRANCH" ]; then
    echo ""
    echo "↩️  Returning to $ORIGINAL_BRANCH..."
    if git switch "$ORIGINAL_BRANCH" 2>/dev/null; then
      echo "✓ Switched back to $ORIGINAL_BRANCH"
    else
      echo "⚠️  Warning: Could not switch back to $ORIGINAL_BRANCH"
      echo "   You are currently on: $(git rev-parse --abbrev-ref HEAD)"
    fi
  fi

  # Restore stash if one was created
  if [ "$STASH_CREATED" = true ]; then
    echo "↩️  Restoring stashed changes..."
    if git stash pop; then
      echo "✓ Stash restored"
    else
      echo "⚠️  Warning: Could not restore stash automatically"
      echo "   Run 'git stash list' to see your stashes"
    fi
  fi

  if [ $exit_code -ne 0 ]; then
    echo ""
    echo "❌ Script failed with exit code $exit_code"
  fi

  exit $exit_code
}

trap cleanup EXIT

# Usage check
if [ $# -ne 1 ]; then
  echo "Usage: $(basename "$0") <branch>"
  echo ""
  echo "This script will:"
  echo "  1. Switch to the target branch"
  echo "  2. Run 'git update' to rebase on remote"
  echo "  3. Force push the rebased branch"
  echo "  4. Return to your original branch"
  exit 1
fi

TARGET_BRANCH="$1"

# Validate we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "❌ Error: Not in a git repository"
  exit 1
fi

# Record current branch
ORIGINAL_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "🔄 Git Remote Rebase"
echo "===================="
echo ""
echo "Current branch: $ORIGINAL_BRANCH"
echo "Target branch:  $TARGET_BRANCH"
echo ""

# Check if target branch exists
if ! git show-ref --verify --quiet "refs/heads/$TARGET_BRANCH"; then
  echo "❌ Error: Branch '$TARGET_BRANCH' does not exist"
  echo ""
  echo "Available branches:"
  git branch --list
  exit 1
fi

# Check if git update command exists
if ! git config --get-regexp '^alias\.update$' > /dev/null; then
  echo "❌ Error: 'git update' command not found"
  echo "   Please configure it as a git alias"
  exit 1
fi

# Check for uncommitted changes
STASH_CREATED=false
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "💾 Stashing local changes..."
  if git stash push -u -m "auto-stash before remote-rebase $(date +%Y-%m-%d_%H:%M:%S)"; then
    STASH_CREATED=true
    echo "✓ Changes stashed"
  else
    echo "❌ Error: Failed to stash changes"
    exit 1
  fi
  echo ""
fi

# Switch to target branch
echo "📍 Checking out $TARGET_BRANCH..."
if ! git switch "$TARGET_BRANCH"; then
  echo "❌ Error: Failed to switch to $TARGET_BRANCH"
  exit 1
fi
SWITCHED_BRANCH=true
echo "✓ Switched to $TARGET_BRANCH"
echo ""

# Check if branch has a remote tracking branch
if ! git rev-parse --abbrev-ref "$TARGET_BRANCH@{upstream}" > /dev/null 2>&1; then
  echo "⚠️  Warning: Branch '$TARGET_BRANCH' has no upstream tracking branch"
  read -p "Continue anyway? (y/n): " continue_choice
  if [[ ! "$continue_choice" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
  fi
  echo ""
fi

# Show current status
COMMITS_BEHIND=$(git rev-list --count HEAD..@{upstream} 2>/dev/null || echo "0")
COMMITS_AHEAD=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")

if [ "$COMMITS_BEHIND" -gt 0 ] || [ "$COMMITS_AHEAD" -gt 0 ]; then
  echo "📊 Branch status:"
  [ "$COMMITS_AHEAD" -gt 0 ] && echo "   ↑ $COMMITS_AHEAD commit(s) ahead"
  [ "$COMMITS_BEHIND" -gt 0 ] && echo "   ↓ $COMMITS_BEHIND commit(s) behind"
  echo ""
fi

# Update branch (rebase)
echo "🔄 Running git update..."
if ! git update; then
  echo "❌ Error: 'git update' failed"
  echo "   Fix conflicts manually and run 'git rebase --continue'"
  exit 1
fi
echo "✓ Branch updated"
echo ""

# Show what will be pushed
echo "📤 Commits to be force-pushed:"
git log --oneline @{upstream}..HEAD 2>/dev/null || echo "   (no upstream to compare)"
echo ""

# Push branch with force-with-lease (safer than -f)
echo ""
echo "🚀 Pushing with --force-with-lease..."
if ! git push --force; then
  echo "❌ Error: Push failed"
  echo "   Someone may have pushed to the remote after you fetched"
  echo "   Run 'git fetch' and try again if needed"
  exit 1
fi
echo "✓ Push successful"
echo ""

echo "✅ Done!"
