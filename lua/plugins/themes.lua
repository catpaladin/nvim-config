local config = require("config")

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
				sidebars = { "qf", "vista_kind", "terminal", "packer", "snacks_explorer" },
				-- Correct diagnostics highlight group names for tokyonight
				on_highlights = function(hl, c)
					hl.DiagnosticError = { fg = c.error }
					hl.DiagnosticWarn = { fg = c.warning }
					hl.DiagnosticInfo = { fg = c.info }
					hl.DiagnosticHint = { fg = c.hint }
				end,
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
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local lualine_sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = {
					{
						function()
							local title = vim.b.term_title or ""
							return title:gsub("term://.*//%d+:", "")
						end,
						cond = function()
							return vim.bo.buftype == "terminal"
						end,
						icon = "",
					},
					"filename",
				},
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			}

			if config.opencode then
				table.insert(lualine_sections.lualine_x, 1, {
					function()
						return require("opencode").statusline()
					end,
					cond = function()
						local ok, opencode = pcall(require, "opencode")
						return ok and opencode.statusline ~= nil
					end,
				})
			end

			require("lualine").setup({
				options = {
					theme = "tokyonight",
					globalstatus = true,
					disabled_filetypes = { statusline = { "dashboard", "alpha", "snacks_dashboard" } },
				},
				sections = lualine_sections,
			})
		end,
	},
}

