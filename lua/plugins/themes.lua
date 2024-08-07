return {
	{ "gruvbox-community/gruvbox" },
	{
		"eldritch-theme/eldritch.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			require("eldritch").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				transparent = true, -- Enable this to disable setting the background color
				terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
				styles = {
					-- Style to be applied to different syntax groups
					-- Value is any valid attr-list value for `:help nvim_set_hl`
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
					-- Background styles. Can be "dark", "transparent" or "normal"
					sidebars = "dark", -- style for sidebars, see below
					floats = "dark", -- style for floating windows
				},
				sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
				hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
				dim_inactive = false, -- dims inactive windows, transparent must be false for this to work
				lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold

				--- You can override specific color groups to use other groups or a hex color
				--- function will be called with a ColorScheme table
				---@param colors ColorScheme
				on_colors = function(colors) end,

				--- You can override specific highlights to use other groups or a hex color
				--- function will be called with a Highlights and ColorScheme table
				---@param highlights Highlights
				---@param colors ColorScheme
				on_highlights = function(highlights, colors) end,
			})
			pcall(vim.cmd, "colorscheme eldritch")
		end,
	},
	{
		"navarasu/onedark.nvim",
		config = function()
			require("onedark").setup({
				-- Main options --
				style = "dark", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
				transparent = false, -- Show/hide background
				term_colors = true, -- Change terminal color as per the selected theme style
				ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
				cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

				-- Lualine options --
				lualine = {
					transparent = true, -- lualine center bar transparency
				},

				-- Custom Highlights --
				colors = {}, -- Override default colors
				highlights = {}, -- Override highlight groups

				-- Plugins Config --
				diagnostics = {
					darker = true, -- darker colors for diagnostic
					undercurl = true, -- use undercurl instead of underline for diagnostics
					background = true, -- use background color for virtual text
				},
			})
			-- pcall(vim.cmd, "colorscheme onedark")
		end,
	},
	{ "KeitaNakamura/neodark.vim" },
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
		end,
	},
	{ "EdenEast/nightfox.nvim" },
	{ "catppuccin/nvim", name = "catppuccin" },
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
					--theme = 'nightfly'
					--theme = "tokyonight"
					theme = "eldritch",
				},
			})
		end,
	},
}
