#!/usr/bin/env bash

set -e
set -u
set -o pipefail

if [ ! -e "$HOME/.tmux/plugins/tpm" ]; then
  printf "Cloning Tmux Plugin Manager\n"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ -e "$HOME/.tmux.conf" ]; then
  printf "Move old tmux config to $HOME/.tmux.conf.backup"
  cp -f "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup" 2>/dev/null || true
fi

cp -a ./tmux/. "$HOME"/.tmux/
ln -sf .tmux/tmux.conf "$HOME"/.tmux.conf;

# Install TPM plugins.
printf "Installing TPM plugins\n"
tmux new -d -s __noop >/dev/null 2>&1 || true 
tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "~/.tmux/plugins"
"$HOME"/.tmux/plugins/tpm/bin/install_plugins || true
tmux kill-session -t __noop >/dev/null 2>&1 || true

printf "Done\n"
