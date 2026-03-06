#!/usr/bin/env bash

git-comment() {
  local diff_content

  diff_content="$(git fshow)"

  if [[ -z "$diff_content" ]]; then
    echo "No diff selected."
    return 1
  fi

  {
    echo "Given this diff, create a commit comment"
	echo "Make sure to include why the change is being done"
    echo
    echo "$diff_content"
  } | pbcopy

  echo "Diff copied to clipboard."
}

git-comment
