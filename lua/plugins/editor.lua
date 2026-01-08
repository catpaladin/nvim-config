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
		},
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
				},
			},
		},
	},

	-- Terminal
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = { "ToggleTerm", "TermExec" },
		keys = { { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" } },
		opts = {
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
			open_mapping = [[<c-\>]],
			hide_numbers = true,
			shade_terminals = true,
			insert_mappings = true,
			persist_size = true,
			direction = "horizontal",
			close_on_exit = true,
			shell = vim.o.shell,
			float_opts = {
				border = "curved",
				winblend = 0,
			},
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)
			for i = 1, 9 do
				vim.keymap.set({ "n", "t" }, string.format("<leader>t%d", i), function()
					require("toggleterm").toggle(i, nil, nil, "horizontal")
				end, { desc = string.format("Toggle Terminal %d", i) })
				vim.keymap.set({ "n", "t" }, string.format("<leader>v%d", i), function()
					require("toggleterm").toggle(i, nil, nil, "vertical")
				end, { desc = string.format("Toggle Vertical Terminal %d", i) })
				vim.keymap.set({ "n", "t" }, string.format("<leader>f%d", i), function()
					require("toggleterm").toggle(i, nil, nil, "float")
				end, { desc = string.format("Toggle Floating Terminal %d", i) })
			end
		end,
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
