git-comment() {
  local diff_content

  diff_content="$(git fshow)"

  if [[ -z "$diff_content" ]]; then
    echo "No diff selected."
    return 1
  fi

  {
    echo "Given this diff, create a commit comment"
    echo
    echo "$diff_content"
  } | pbcopy

  echo "Diff copied to clipboard."
}

git-description() {
  local base
  local diff_content
  local template_file
  local template_content

  base="$(git default-branch)"

  # Get diff from merge-base (correct for PRs)
  diff_content="$(git diff "$base"...HEAD)"

  if [[ -z "$diff_content" ]]; then
    echo "No diff found against $base."
    return 1
  fi

  # Try common PR template locations
  if [[ -f ".github/pull_request_template.md" ]]; then
    template_file=".github/pull_request_template.md"
  elif [[ -f ".github/PULL_REQUEST_TEMPLATE.md" ]]; then
    template_file=".github/PULL_REQUEST_TEMPLATE.md"
  elif [[ -f ".github/pull_request_template/pull_request_template.md" ]]; then
    template_file=".github/pull_request_template/pull_request_template.md"
  else
    echo "No PR template found in .github/"
    return 1
  fi

  template_content="$(cat "$template_file")"

  {
	echo "Given this diff"
    echo
    echo '```diff'
    echo "$diff_content"
    echo '```'
	echo 
	echo "Fill out this pull request template"
	echo
    echo "$template_content"
  } | pbcopy

  echo "PR prompt copied to clipboard (diff vs $base using $template_file)."
}

