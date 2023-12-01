#!/usr/bin/env zsh
# shellcheck disable=SC1090

# Exit if the 'fnm' command can not be found
if ! (( $+commands[fnm] )); then
    echo "WARNING: 'fnm' command not found"
    return
fi

# Add 'fnm' environment variables for 'zsh'
# Add hook to change Node version on change directory
eval "$(fnm env --shell zsh --use-on-cd)"

# Completions directory for `fnm` command
local COMPLETIONS_DIR="${0:A:h}/completions"

# Only regenerate completions if older than 24 hours, or does not exist
if [[ ! -f "$COMPLETIONS_DIR/_fnm"  ||  ! $(find "$COMPLETIONS_DIR/_fnm" -newermt "7 days ago" -print) ]]; then
    fnm completions --shell zsh >| "$COMPLETIONS_DIR/_fnm"
fi

# Add completions to the FPATH
typeset -TUx FPATH fpath
fpath=("$COMPLETIONS_DIR" $fpath)
