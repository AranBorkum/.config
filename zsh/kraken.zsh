export PATH="/Applications/Postgres.app/Contents/Versions/15/bin:$PATH"

kraken-db(){
  ktdb connect "${1:-$KRAKEN_CLIENT}-prod.krakencore"
}
kraken-db-t(){
  ktdb connect "${1:-$KRAKEN_CLIENT}-test.krakencore"
}

alias all-dbs='ktdb run group:krakencore-prod'
alias all-dbs-t='ktdb run group:krakencore-test'
alias all-dbs-all='ktdb run group:krakencore-prod group:krakencore-test'

alias integrity-results='ktdb run-template kraken-integrity-check-results group:krakencore-prod --check-name'
alias integrity-results-t='ktdb run-template kraken-integrity-check-results group:krakencore-test --check-name'
alias integrity-results-all='ktdb run-template kraken-integrity-check-results group:krakencore-prod group:krakencore-test --check-name'

alias kraken-settings='ktdb run-template kraken-db-settings group:krakencore-prod --key'
alias kraken-settings-t='ktdb run-template kraken-db-settings group:krakencore-test --key'
alias kraken-settings-all='ktdb run-template kraken-db-settings group:krakencore-prod group:krakencore-test --key'

cwt() {
  # list worktrees, show only the paths
  local dir
  dir=$(git worktree list --porcelain | awk '/^worktree / {print $2}' | fzf --prompt="Worktree> ")
  if [ -n "$dir" ]; then
    # Deactivate current venv if active
    if [ -n "$VIRTUAL_ENV" ]; then
      echo "Deactivating venv: $VIRTUAL_ENV"
      deactivate
    fi

    cd "$dir" || return
    echo "Switched to worktree: $dir"

    # Activate venv in new worktree if present
    if [ -f "$dir/.venv/bin/activate" ]; then
      echo "Activating venv: $dir/.venv"
      source "$dir/.venv/bin/activate"
    fi
  fi
}
