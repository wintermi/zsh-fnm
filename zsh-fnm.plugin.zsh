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

# Add completions to the FPATH
typeset -TUx FPATH fpath
fpath=("$COMPLETIONS_DIR" $fpath)

# If the completion file does not exist yet, then we need to autoload
# and bind it to `fnm`. Otherwise, compinit will have already done that.
if [[ ! -f "$COMPLETIONS_DIR/_fnm" ]]; then
    typeset -g -A _comps
    autoload -Uz _fnm
    _comps[fnm]=_fnm
fi

# Generate and load completion in the background
fnm completions --shell zsh >| "$COMPLETIONS_DIR/_fnm" &|