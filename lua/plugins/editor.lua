	return {
	-- Notifications and UI utilities
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			notifier = { enabled = true, timeout = 3000 },
			quickfile = { enabled = true },
			bufdelete = { enabled = true },
			explorer = { enabled = true },
			lazygit = { enabled = true },
			picker = {
				sources = {
					explorer = { hidden = true },
				},
			},
			indent = {
				enabled = true,
				char = "│",
				scope = { enabled = true },
			},
			dashboard = { enabled = false },
			statuscolumn = { enabled = false },
			words = { enabled = false },
			terminal = {
				win = {
					wo = { winbar = "%{b:term_title}" },
				},
			},
		},
		keys = {
			{
				"<leader>n",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Notification History",
			},
			{
				"<leader>un",
				function()
					Snacks.notifier.hide()
				end,
				desc = "Dismiss All Notifications",
			},
			{
				"<C-\\>",
				function()
					Snacks.terminal()
				end,
				desc = "Toggle Terminal",
				mode = { "n", "t" },
			},
		},
		config = function(_, opts)
			require("snacks").setup(opts)

			for i = 1, 9 do
				vim.keymap.set({ "n", "t" }, string.format("<leader>t%d", i), function()
					Snacks.terminal(nil, { win = { position = "bottom" }, count = i })
				end, { desc = string.format("Toggle Terminal %d", i) })
				vim.keymap.set({ "n", "t" }, string.format("<leader>v%d", i), function()
					Snacks.terminal(nil, { win = { position = "right" }, count = i })
				end, { desc = string.format("Toggle Vertical Terminal %d", i) })
				vim.keymap.set({ "n", "t" }, string.format("<leader>f%d", i), function()
					Snacks.terminal(vim.o.shell, { win = { position = "float" }, count = i })
				end, { desc = string.format("Toggle Floating Terminal %d", i) })
			end
		end,
	},

	-- Buffer line
	{
		"akinsho/bufferline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			options = {
				mode = "buffers",
				separator_style = "slant",
				always_show_bufferline = true,
				show_buffer_close_icons = true,
				show_close_icon = false,
				color_icons = true,
				diagnostics = "nvim_lsp",
				diagnostics_update_in_insert = false,
				diagnostics_indicator = function(count, level)
					local icon = level:match("error") and " " or " "
					return " " .. icon .. count
				end,
				offsets = {
					{
						filetype = "snacks_explorer",
						text = "File Explorer",
						highlight = "Directory",
						text_align = "left",
					},
					{
						filetype = "snacks_terminal",
						text = "Terminal",
						highlight = "Special",
						text_align = "left",
					},
				},
			},
		},
	},

	-- Markdown rendering (in-buffer)
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown render" },
		},
		opts = {
			heading = {
				icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
			},
			code = {
				sign = false,
				width = "block",
				right_pad = 1,
			},
			bullet = {
				icons = { "●", "○", "◆", "◇" },
			},
		},
	},

	-- Find and replace
	{
		"MagicDuck/grug-far.nvim",
		cmd = { "GrugFar" },
		keys = {
			{ "<leader>fr", "<cmd>GrugFar<cr>", desc = "Find and Replace" },
		},
		opts = {
			ignore_patterns = { "%.git/", "node_modules/", "%.cache/", "build/", "dist/" },
			default_options = {
				confirm_replace = true,
				match_case = false,
				whole_word = false,
				use_regex = false,
			},
		},
		config = function(_, opts)
			require("grug-far").setup(opts)
			vim.g.maplocalleader = ","
		end,
	},
}
