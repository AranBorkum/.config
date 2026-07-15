#!/usr/bin/env bash
#
# common.sh: Shared functions for git subcommands
#
# This file should be sourced by git subcommands, not executed directly

# Colors for output
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export NC='\033[0m' # No Color

# Validate we're in a git repository
validate_in_git_repo() {
	if ! git rev-parse --git-dir > /dev/null 2>&1; then
		echo -e "${RED}❌ Error: Not in a git repository${NC}"
		exit 1
	fi
}

# Get current branch, exit if in detached HEAD state
get_current_branch() {
	local branch
	branch=$(git rev-parse --abbrev-ref HEAD)

	if [ "$branch" = "HEAD" ]; then
		echo -e "${RED}❌ Error: Not on a branch (detached HEAD state)${NC}"
		exit 1
	fi

	echo "$branch"
}

# Get the default branch (master or main)
get_default_branch() {
	local branch
	branch=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@^origin/@@')

	if [ -z "$branch" ]; then
		# Try local branches
		if git show-ref --verify --quiet refs/heads/master; then
			branch="master"
		elif git show-ref --verify --quiet refs/heads/main; then
			branch="main"
		else
			# Try remote branches
			if git ls-remote --exit-code --heads origin master >/dev/null 2>&1; then
				branch="master"
			elif git ls-remote --exit-code --heads origin main >/dev/null 2>&1; then
				branch="main"
			else
				echo -e "${RED}❌ Error: Could not find master or main branch${NC}" >&2
				exit 1
			fi
		fi
	fi

	echo "$branch"
}

# Check if current branch is the default branch
is_on_default_branch() {
	local current="$1"
	local default="$2"

	if [ "$current" = "$default" ]; then
		return 0
	else
		return 1
	fi
}

# Count commits on current branch not in base branch
count_commits_on_branch() {
	local base_branch="$1"
	local count

	count=$(git rev-list --count HEAD --not "$base_branch" 2>/dev/null || echo "0")
	echo "$count"
}

# Check for uncommitted changes
has_uncommitted_changes() {
	if ! git diff-index --quiet HEAD -- 2>/dev/null; then
		return 0
	else
		return 1
	fi
}

# Print standard header for git subcommands
print_header() {
	local title="$1"
	local current_branch="$2"
	local default_branch="$3"

	echo -e "${BLUE}$title${NC}"
	echo -e "${BLUE}$(printf '=%.0s' $(seq 1 ${#title}))${NC}"
	echo ""
	echo -e "${BLUE}Current branch:${NC} $current_branch"
	echo -e "${BLUE}Base branch:${NC}    $default_branch"
	echo ""
}

# Print rebase error help
print_rebase_error_help() {
	echo ""
	echo -e "${RED}❌ Rebase failed${NC}"
	echo ""
	echo "To continue after resolving conflicts:"
	echo "  git rebase --continue"
	echo ""
	echo "To abort the rebase:"
	echo "  git rebase --abort"
}
