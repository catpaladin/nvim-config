return {
  {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup({
        -- use the night style
        style = "storm",
        -- disable italic for functions
        styles = {
          functions = {},
        },
        sidebars = { "qf", "vista_kind", "terminal", "packer" },
        -- Change the "hint" color to the "orange" color, and make the "error" color bright red
        on_colors = function(colors)
          colors.hint = colors.orange
          colors.error = "#ff0000"
        end,
      })

      pcall(vim.cmd, "colorscheme tokyonight-storm")
    end,
  },
  -- status line
  {
    "nvim-lualine/lualine.nvim",
    requires = {
      "kyazdani42/nvim-web-devicons",
      opt = true,
    },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
        },
      })
    end,
  },
}
