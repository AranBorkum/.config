#!/usr/bin/env bash

print_status() {
    local TAG="$1"
    local STATUS="$2"  # 0 = success, non-zero = failure

    if [[ "$STATUS" -eq 0 ]]; then
        echo -e "\r$TAG ✔"
    else
        echo -e "\r$TAG ✖"
    fi
}

install_brew_and_dependencies() {
    local BREWFILE="$1"
    local TAG="Installing brew and dependencies..."

    echo -n "$TAG"

    # Install Homebrew if missing
    if ! command -v brew >/dev/null 2>&1; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install dependencies if needed
    if [[ $(brew bundle check --file="$BREWFILE" >/dev/null 2>&1; echo $?) -ne 0 ]]; then
        echo "Updates found — running brew bundle install..."
        brew bundle install --file="$BREWFILE"
    fi

    print_status "$TAG" "$?"
}

install_cargo_crate() {
    local CRATE_NAME="$1"
    local EXECUTABLE_NAME="${2:-$CRATE_NAME}"
    local TAG="Installing $CRATE_NAME crate..."

    echo -n "$TAG"

    if ! command -v "$EXECUTABLE_NAME" >/dev/null 2>&1; then
        cargo install "$CRATE_NAME"
    fi

    print_status "$TAG" "$?"
}

create_symlink() {
    local TARGET="$1"
    local LINK_NAME="$2"
    local TAG="Creating symlink to $LINK_NAME..."

    echo -n "$TAG"

    if [[ -z "$TARGET" || -z "$LINK_NAME" ]]; then
        print_status "$TAG" 1
        return 1
    fi

    if ! [[ -L "$LINK_NAME" ]]; then
        ln -s "$TARGET" "$LINK_NAME"
    fi

    print_status "$TAG" "$?"
}

install_or_update_uv_tool() {
    local INSTALLABLE="$1"
    local EXECUTABLE="$2"  # optional
	local TAG="Installing and/or updating $EXECUTABLE with uv..."
	
	echo -n "$TAG"

    if [[ -z "$INSTALLABLE" ]]; then
        echo "Usage: install_or_update_uv_tool <git_link> [executable_name]"
        return 1
    fi

    # Ensure uv is installed
    if ! command -v uv >/dev/null 2>&1; then
        echo "Error: uv is not installed. Please install uv first."
        return 1
    fi

    # Determine if the executable is already installed (if provided)
    if [[ -n "$EXECUTABLE" ]] && command -v "$EXECUTABLE" >/dev/null 2>&1; then
        uv tool update "$EXECUTABLE" &>/dev/null || STATUS=1
    else
        uv tool install "$INSTALLABLE" &>/dev/null || STATUS=1
    fi

    print_status "$TAG" "$?"
}
