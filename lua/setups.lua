-- setup nvim-tree with settings
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
})

-- setup lualine
require('lualine').setup {
  options = {
    theme = 'dracula-nvim'
  }
}

-- setup autopairs
require('nvim-autopairs').setup{}

-- setup glow
require('glow').setup({
  style = "dark",
  width = 120,
})

-- setup fzf-lua
require('fzf-lua').setup{
  winopts = {
    hl = { border = "FloatBorder", }
  }
}

-- setup nvim-lspconfig languages
require('lspconfig').gopls.setup{}
require('lspconfig').pyright.setup{}
require('lspconfig').terraform_lsp.setup{}
