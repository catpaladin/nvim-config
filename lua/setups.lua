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
