return {
	"folke/edgy.nvim",
	event = "VeryLazy",
	opts = {
		left = {
			{
				ft = "snacks_explorer",
				title = "Explorer",
				pinned = true,
				open = function()
					Snacks.explorer()
				end,
			},
		},
		right = {
			{
				ft = "opencode",
				title = "OpenCode",
				size = { width = 0.3 },
			},
			{
				ft = "claude",
				title = "Claude",
				size = { width = 0.3 },
			},
		},
		bottom = {
			{
				ft = "snacks_terminal",
				title = "Terminal",
				size = { height = 0.4 },
				filter = function(buf, win)
					return vim.api.nvim_win_get_config(win).relative == ""
				end,
			},
			{
				ft = "qf",
				title = "Quickfix",
			},
			{
				ft = "help",
				size = { height = 20 },
				filter = function(buf)
					return vim.bo[buf].buftype == "help"
				end,
			},
		},
	},
}
