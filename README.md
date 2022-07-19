# Lua config settings

Clone this repo under `$HOME/.config/nvim`

## Install Dependencies
Brew install neovim
```
# need version 0.7.0 or greater
brew install neovim
```

Setup [pyenv](https://github.com/pyenv/pyenv)

(optional) Setup [goenv](https://github.com/syndbg/goenv)

(optional) Setup [tfenv](https://github.com/tfutils/tfenv)

Brew install other dependencies
```
brew install fzf ripgrep tmux
```

### Install language servers
```
# python
pip3 install pynvim jedi pyright --user

# go
go install golang.org/x/tools/gopls@latest

# terraform
go install github.com/hashicorp/terraform-ls@v0.28.1
```

## Install Font
Brew install the font
```
brew tap homebrew/cask-fonts
brew install font-hack-nerd-font
```

Select the font in iterm / terminal

## Initialize
Use nvim to open `lua/plugins.lua`

Write changes and Packer will install all dependencies

## tmux setup (optional)
```
# run script to setup symmlink
./install.sh

# clone tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# clone tmux resurrect
git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect

# source tmux
tmux source ~/.tmux.conf
```
