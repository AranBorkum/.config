#!/usr/bin/env bash
set -euo pipefail

CURRENT_BRANCH=""
DEFAULT_BRANCH_NAME=""
BASE_REF=""
COMMIT_COUNT=""
SELECTED_COMMIT=""
EXIT_CODE=0

validate_in_git_repository() {
	if ! git rev-parse --git-dir > /dev/null 2>&1; then
		echo "❌ Error: Not in a git repository"
		exit 1
	fi
}

get_current_branch() {
	CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

	if [ "$CURRENT_BRANCH" = "HEAD" ]; then
		echo "❌ Error: Not on a branch (detached HEAD state)"
		exit 1
	fi
}

get_default_branch() {
	DEFAULT_BRANCH_NAME=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@^origin/@@' || echo "main")

	# Determine the best base ref to compare against.
	# Prioritize the remote tracking branch (origin/...) for git worktrees.
	if git show-ref --verify --quiet "refs/remotes/origin/$DEFAULT_BRANCH_NAME"; then
		BASE_REF="origin/$DEFAULT_BRANCH_NAME"
	elif git show-ref --verify --quiet "refs/heads/$DEFAULT_BRANCH_NAME"; then
		BASE_REF="$DEFAULT_BRANCH_NAME"
	else
		# Fallback to master
		DEFAULT_BRANCH_NAME="master"
		if git show-ref --verify --quiet "refs/remotes/origin/$DEFAULT_BRANCH_NAME"; then
			BASE_REF="origin/$DEFAULT_BRANCH_NAME"
		elif git show-ref --verify --quiet "refs/heads/$DEFAULT_BRANCH_NAME"; then
			BASE_REF="$DEFAULT_BRANCH_NAME"
		else
			echo "❌ Error: Could not find default branch (main/master) locally or on origin"
			exit 1
		fi
	fi
}

validate_not_on_default_branch() {
	if [ "$CURRENT_BRANCH" = "$DEFAULT_BRANCH_NAME" ]; then
		echo "❌ Error: Cannot interactively rebase the default branch"
		exit 1
	fi
}

get_number_of_commits_on_branch() {
	COMMIT_COUNT=$(git rev-list --count HEAD --not "$BASE_REF" 2>/dev/null || echo "0")

	if [ "$COMMIT_COUNT" -eq 0 ]; then
		echo "ℹ️  No commits to rebase (branch is up to date with $BASE_REF)"
		exit 0
	fi
}

select_commit_to_fixup_against() {
	SELECTED_COMMIT=$(git log "$CURRENT_BRANCH" --pretty=format:'%h %s' --no-merges --not "$BASE_REF" | fzf --prompt="Select commit: " | cut -c -7)

	if [ -z "$SELECTED_COMMIT" ]; then
		echo "❌ Cancelled"
		exit 1
	fi
}

main() {
	validate_in_git_repository 
	get_current_branch 
	get_default_branch 
	validate_not_on_default_branch 
	get_number_of_commits_on_branch 	
	select_commit_to_fixup_against 

	git commit --fixup="$SELECTED_COMMIT"
}

main
