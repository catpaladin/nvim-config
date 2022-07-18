#!/usr/bin/env bash

function configure() {
  rm -f $HOME/.alacritty.yml || echo "No alacritty config file found."
  ln -s $HOME/.config/nvim/terminal-settings/alacritty.yml $HOME/.alacritty.yml && \
    echo "Symmlink created for alacritty."

  rm -f $HOME/.tmux.conf || echo "No tmux configuration found."
  ln -s $HOME/.config/nvim/terminal-settings/tmux.conf $HOME/.tmux.conf && \
    echo "Symmlink created for tmux."
}

function main() {
  # check if symmlinks exist or setup symmlinks.
  ([ -L $HOME/.tmux.conf ] && [ -L $HOME/.alacritty.yml ] && echo "symmlinks exist.") || \
    (configure && echo "run configure.")
}

git pull
main
tmux source ~/.tmux.conf
