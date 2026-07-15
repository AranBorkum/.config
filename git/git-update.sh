#!/usr/bin/env bash
set -euo pipefail



# Validate we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "❌ Error: Not in a git repository"
  exit 1
fi

# Get current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ "$CURRENT_BRANCH" = "HEAD" ]; then
  echo "❌ Error: Not on a branch (detached HEAD state)"
  exit 1
fi

echo "🔄 Git Update"
echo "============="
echo ""
echo "Current branch: $CURRENT_BRANCH"

# Get the default branch (master or main)
DEFAULT_BRANCH=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@^origin/@@' || echo "main")

# Verify default branch exists
if ! git show-ref --verify --quiet "refs/heads/$DEFAULT_BRANCH" && \
   ! git show-ref --verify --quiet "refs/remotes/origin/$DEFAULT_BRANCH"; then
  # Fallback to master
  DEFAULT_BRANCH="master"
  if ! git show-ref --verify --quiet "refs/heads/$DEFAULT_BRANCH" && \
     ! git show-ref --verify --quiet "refs/remotes/origin/$DEFAULT_BRANCH"; then
    echo "❌ Error: Could not find default branch (main/master)"
    exit 1
  fi
fi

echo "Base branch:    $DEFAULT_BRANCH"
echo ""

# Check if we're on the default branch
if [ "$CURRENT_BRANCH" = "$DEFAULT_BRANCH" ]; then
  echo "ℹ️  You are on the default branch"
  echo "   Pulling latest changes..."
  echo ""

  if git pull --rebase --autostash; then
    echo ""
    echo "✅ Done!"
  else
    echo ""
    echo "❌ Error: Pull failed"
    exit 1
  fi
  exit 0
fi

# Fetch the latest from origin
echo "📥 Fetching from origin..."
if ! git fetch origin; then
  echo "❌ Error: Fetch failed"
  exit 1
fi
echo "✓ Fetch complete"
echo ""

# Check if the default branch is checked out in another worktree
BRANCH_LOCKED=false
if git worktree list --porcelain | grep -q "branch refs/heads/$DEFAULT_BRANCH"; then
  # Default branch is checked out in a worktree, we'll rebase onto origin/DEFAULT_BRANCH
  BRANCH_LOCKED=true
  REBASE_TARGET="origin/$DEFAULT_BRANCH"
  echo "ℹ️  $DEFAULT_BRANCH is checked out in a worktree"
else
  # Try to update the local default branch
  if git fetch origin "$DEFAULT_BRANCH:$DEFAULT_BRANCH" 2>/dev/null; then
    REBASE_TARGET="$DEFAULT_BRANCH"
    echo "✓ Updated local $DEFAULT_BRANCH branch"
  else
    # Fallback to origin/DEFAULT_BRANCH
    REBASE_TARGET="origin/$DEFAULT_BRANCH"
    echo "⚠️  Could not update local $DEFAULT_BRANCH, using origin/$DEFAULT_BRANCH"
  fi
fi
echo ""

# Show commits that will be rebased
COMMITS_TO_REBASE=$(git rev-list --count "$REBASE_TARGET".."$CURRENT_BRANCH" 2>/dev/null || echo "0")

if [ "$COMMITS_TO_REBASE" -eq 0 ]; then
  echo "ℹ️  No commits to rebase (already up to date with $REBASE_TARGET)"
  exit 0
fi

echo "📊 Rebasing $COMMITS_TO_REBASE commit(s) onto $REBASE_TARGET"
echo ""

# Rebase onto the target branch
echo "🔀 Rebasing..."
if git rebase "$REBASE_TARGET" --update-refs --autostash; then
  echo ""
  echo "✅ Done! Branch rebased onto $REBASE_TARGET"
else
  EXIT_CODE=$?
  echo ""
  echo "❌ Rebase failed"
  echo ""
  echo "To continue after resolving conflicts:"
  echo "  git rebase --continue"
  echo ""
  echo "To abort the rebase:"
  echo "  git rebase --abort"
  exit $EXIT_CODE
fi













