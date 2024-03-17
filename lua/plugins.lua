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
  use 'wbthomason/packer.nvim'  -- Have packer manage itself
  use "nvim-lua/popup.nvim"     -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim"   -- Useful lua functions used by lots of plugins
  use 'akinsho/toggleterm.nvim' -- terminals
  use "akinsho/bufferline.nvim" -- add buffers
  use "moll/vim-bbye"           -- used to close buffers
  use 'rcarriga/nvim-notify'
  use "j-hui/fidget.nvim"       -- lsp progress
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  }
  use { 'DanilaMihailov/beacon.nvim' } -- cursor jump
  use {
    'nvim-lualine/lualine.nvim',       -- statusline
    requires = {
      'kyazdani42/nvim-web-devicons',
      opt = true,
    }
  }

  -- [[ Theme ]]
  use { "folke/tokyonight.nvim" }
  use { "navarasu/onedark.nvim" }

  -- [[ Dev ]]
  use { 'windwp/nvim-autopairs' }               -- close brackets, etc
  use { 'lukas-reineke/indent-blankline.nvim' } -- show indents
  use { 'ray-x/lsp_signature.nvim' }            -- show function signature
  use { 'RRethy/vim-illuminate' }               -- highlight usage
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }                                                 -- fuzzy find
  use { 'nvim-telescope/telescope-ui-select.nvim' } -- telescope ui

  -- [[ LSP ]]
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  }
  use { "mhartington/formatter.nvim" } -- for lang formatting
  use { 'nvimdev/lspsaga.nvim' }
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua",                after = "nvim-cmp" },
      { "hrsh7th/cmp-buffer",                  after = "nvim-cmp" },
      { "hrsh7th/cmp-path",                    after = "nvim-cmp" },
      { "hrsh7th/cmp-cmdline",                 after = "nvim-cmp" },
      { "hrsh7th/cmp-calc",                    after = "nvim-cmp" },
      { "lukas-reineke/cmp-rg",                after = "nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" },
    },
    config   = function() require("settings.cmp") end,
  })
  use {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
  }
  use {
    "Exafunction/codeium.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({
      })
    end
  } -- code complete AI

  -- [[ Languages ]]
  use { "rafamadriz/friendly-snippets" }
  use {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "go",
          "html",
          "javascript",
          "json",
          "markdown",
          "markdown_inline",
          "python",
          "rust",
          "toml",
          "typescript",
          "tsx",
        }
      }
    end
  }
  use { "folke/neodev.nvim" }                  -- lua
  use { 'crispgm/nvim-go' }                    -- golang
  use { 'hashivim/vim-terraform' }             -- terraform
  use { 'simrat39/rust-tools.nvim' }           -- rust
  use { "jose-elias-alvarez/typescript.nvim" } -- typescript

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end)
