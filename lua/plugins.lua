local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path })
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
  -- [[ Base plugins ]]
  use 'wbthomason/packer.nvim' -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used by lots of plugins
  use 'voldikss/vim-floaterm' -- floating window
  use 'rcarriga/nvim-notify'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  -- [[ Theme ]]
  use { 'DanilaMihailov/beacon.nvim' } -- cursor jump
  use {
    'nvim-lualine/lualine.nvim', -- statusline
    requires = {
      'kyazdani42/nvim-web-devicons',
      opt = true,
    }
  }
  --use { 'Mofiqul/dracula.nvim' }
  use { 'EdenEast/nightfox.nvim' }

  -- [[ Dev ]]
  use { 'windwp/nvim-autopairs' } -- close brackets, etc
  use { 'Yggdroot/indentLine' } -- show indents
  use { 'ray-x/lsp_signature.nvim' } -- show function signature
  use { 'RRethy/vim-illuminate' } -- highlight usage
  use { 'jremmen/vim-ripgrep' } -- pure ripgrep
  use { 'ibhagwan/fzf-lua',
    -- optional for icon support
    requires = { 'kyazdani42/nvim-web-devicons' }
  }
  use { 'junegunn/fzf', run = './install --bin' }

  -- [[ LSP ]]
  use {
    "williamboman/nvim-lsp-installer",
    "neovim/nvim-lspconfig",
  }
  use {
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  }
  use "folke/lua-dev.nvim" -- lua
  use 'crispgm/nvim-go' -- golang
  use 'fatih/vim-go' -- golang
  use 'davidhalter/jedi-vim' -- python
  use 'hashivim/vim-terraform' -- terraform

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end)
