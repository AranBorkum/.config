#!/usr/bin/env bash

git-krak() {
    echo "🔍 Git Bisect Helper"
    echo "===================="
    echo ""

    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Error: Not in a git repository"
        return 1
    fi

    # Check if bisect is already running
    if [ -d "$(git rev-parse --git-dir)/BISECT_START" ]; then
        echo "⚠️  A bisect session is already in progress"
        read -p "Do you want to reset it? (y/n): " reset_choice
        if [[ "$reset_choice" =~ ^[Yy]$ ]]; then
            git bisect reset
            echo "✓ Bisect reset"
        else
            echo "Exiting..."
            return 1
        fi
    fi

    # Prompt for number of commits
    echo "How many commits back should we check?"
    echo "Examples: 2, 4, 8, 16, 32, 64, 128, 256"
    read -p "Number of commits: " num_commits

    # Validate input
    if ! [[ "$num_commits" =~ ^[0-9]+$ ]] || [ "$num_commits" -lt 1 ]; then
        echo "❌ Error: Please enter a valid positive number"
        return 1
    fi

    # Get the commit hash from N commits ago
    bad_commit=$(git rev-parse HEAD)
    good_commit=$(git rev-parse HEAD~"$num_commits" 2>/dev/null)

    if [ -z "$good_commit" ]; then
        echo "❌ Error: Not enough commits in history"
        return 1
    fi

    echo ""
    echo "Bisecting between:"
    echo "  BAD (current):  $bad_commit"
    echo "  GOOD ($num_commits back): $good_commit"
    echo ""

    # Prompt for test command
    echo "Enter the command to test each commit"
    echo "The command should:"
    echo "  - Exit 0 if the commit is GOOD"
    echo "  - Exit 1-127 (except 125) if the commit is BAD"
    echo "  - Exit 125 if the commit is untestable (skip)"
    echo ""
    echo "Examples:"
    echo "  npm test"
    echo "  make && make test"
    echo "  python -m pytest tests/"
    echo "  cargo test"
    echo ""
    read -p "Test command: " test_cmd

    if [ -z "$test_cmd" ]; then
        echo "❌ Error: Test command cannot be empty"
        return 1
    fi

    echo ""
    echo "Starting bisect..."

    # Start bisect
    git bisect start
    git bisect bad "$bad_commit"
    git bisect good "$good_commit"

    echo ""
    echo "Running bisect with command: $test_cmd"
    echo "==============================================="
    echo ""

    # Run bisect
    git bisect run sh -c "$test_cmd"

    echo ""
    echo "==============================================="
    echo "Bisect complete! Review the results above."
    echo ""
    read -p "Reset bisect now? (y/n): " reset_choice

    if [[ "$reset_choice" =~ ^[Yy]$ ]]; then
        git bisect reset
        echo "✓ Bisect reset to original HEAD"
    else
        echo "ℹ️  Run 'git bisect reset' manually when done"
    fi
}

git-krak
