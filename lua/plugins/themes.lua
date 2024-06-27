return {
	{ "gruvbox-community/gruvbox" },
	{
		"navarasu/onedark.nvim",
		config = function()
      require('onedark').setup {
        -- Main options --
        style = 'deep',               -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
        transparent = false,          -- Show/hide background
        term_colors = true,           -- Change terminal color as per the selected theme style
        ending_tildes = false,        -- Show the end-of-buffer tildes. By default they are hidden
        cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

        -- Lualine options --
        lualine = {
          transparent = true, -- lualine center bar transparency
        },

        -- Custom Highlights --
        colors = {},     -- Override default colors
        highlights = {}, -- Override highlight groups

        -- Plugins Config --
        diagnostics = {
          darker = true,     -- darker colors for diagnostic
          undercurl = true,  -- use undercurl instead of underline for diagnostics
          background = true, -- use background color for virtual text
        },
      }
			pcall(vim.cmd, "colorscheme onedark")
		end,
	},
	{ "KeitaNakamura/neodark.vim" },
	{
    "folke/tokyonight.nvim",
      config = function()
        require("tokyonight").setup({
          -- use the night style
          style = "night",
          -- disable italic for functions
          styles = {
            functions = {}
          },
          sidebars = { "qf", "vista_kind", "terminal", "packer" },
          -- Change the "hint" color to the "orange" color, and make the "error" color bright red
          on_colors = function(colors)
            colors.hint = colors.orange
            colors.error = "#ff0000"
          end
        })
      end,
  },
	{ "EdenEast/nightfox.nvim" },
	{ "catppuccin/nvim", name = "catppuccin" },
  -- status line
  {
    'nvim-lualine/lualine.nvim',
    requires = {
      'kyazdani42/nvim-web-devicons',
      opt = true,
    },
    config = function()
      require('lualine').setup {
        options = {
          --theme = 'nightfly'
          --theme = "tokyonight"
          theme = "onedark"
        }
      }
    end,
  },
}
