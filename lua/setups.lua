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
    --theme = 'dracula-nvim'
    theme = 'codedark'
  }
}

-- setup autopairs
require('nvim-autopairs').setup {}

-- setup fzf-lua
require('fzf-lua').setup {
  winopts = {
    hl = { border = "FloatBorder", }
  }
}

-- setup indent-blankline
require("indent_blankline").setup {
  -- for example, context is off by default, use this to turn it on
}
