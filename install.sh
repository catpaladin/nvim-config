#!/usr/bin/env bash

configure() {
  rm -f $HOME/.alacritty.yml || echo "No alacritty config file found."
  if [ $(uname) = 'Darwin' ]; then
    ln -s $HOME/.config/nvim/terminal-settings/alacritty-darwin.yml $HOME/.alacritty.yml && \
      echo "Symmlink created for alacritty."
  else
    ln -s $HOME/.config/nvim/terminal-settings/alacritty-linux.yml $HOME/.alacritty.yml && \
      echo "Symmlink created for alacritty."
  fi

  rm -f $HOME/.tmux.conf || echo "No tmux configuration found."
  ln -s $HOME/.config/nvim/terminal-settings/tmux.conf $HOME/.tmux.conf && \
    echo "Symmlink created for tmux."
}

main() {
  # check if symmlinks exist or setup symmlinks.
  ([ -L $HOME/.tmux.conf ] && [ -L $HOME/.alacritty.yml ] && echo "symmlinks exist.") || \
    (configure && echo "run configure.")
}

git pull
main
tmux source ~/.tmux.conf
