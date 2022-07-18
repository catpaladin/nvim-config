local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  print("Installing packer close and reopen Neovim...")
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end
    }
  }
)

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use 'wbthomason/packer.nvim' -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used by lots of plugins

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  -- old vim plugins --
  -- {{ General QoL }}
  use 'vim-airline/vim-airline' -- status bar
  use 'vim-airline/vim-airline-themes'
  use 'jiangmiao/auto-pairs'    -- autopair brackets
  use 'sheerun/vim-polyglot'    -- syntax support
  use 'voldikss/vim-floaterm'   -- floating window
  use 'preservim/nerdcommenter' -- better comment/uncomment
  use 'ap/vim-css-color'        -- hex color highlighter

  -- {{ Search }}
  use 'junegunn/fzf'
  use 'mileszs/ack.vim'     -- ack use ripgrep
  use 'jremmen/vim-ripgrep' -- pure ripgrep
  use 'stefandtw/quickfix-reflector.vim' -- quick replace

  -- {{ lsp settings and servers }}
  use 'prabirshrestha/asyncomplete-lsp.vim'
  use 'prabirshrestha/asyncomplete.vim'
  use 'prabirshrestha/vim-lsp'
  use 'mattn/vim-lsp-settings'
  use 'prabirshrestha/async.vim'
  use 'Shougo/deoplete.nvim'
  use 'davidhalter/jedi-vim' -- python
  use 'fatih/vim-go' -- golang

  -- {{ terraform plugins }}
  use 'hashivim/vim-terraform'
  use 'juliosueiras/vim-terraform-completion'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end)
