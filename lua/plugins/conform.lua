return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>fm",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "n",
				desc = "Format buffer",
			},
		},
		opts = {
			-- Define formatters by filetype
			formatters_by_ft = {
				-- Web development
				javascript = { "prettierd", "prettier" },
				typescript = { "prettierd", "prettier" },
				javascriptreact = { "prettierd", "prettier" },
				typescriptreact = { "prettierd", "prettier" },
				svelte = { "prettierd", "prettier" },
				astro = { "prettierd", "prettier" },
				css = { "prettierd", "prettier" },
				html = { "prettierd", "prettier" },
				json = { "prettierd", "prettier" },
				yaml = { "prettierd", "prettier" },
				markdown = { "prettierd", "prettier" },
				graphql = { "prettierd", "prettier" },

				-- Lua
				lua = { "stylua" },

				-- Go
				go = function(bufnr)
					local conform = require("conform")
					if conform.get_formatter_info("goimports-reviser", bufnr).available then
						-- Option 1: Replace gofumpt/gofmt with goimports
						return { "goimports-reviser", "goimports" }
					elseif conform.get_formatter_info("goimports", bufnr).available then
						-- Option 2: Use goimports as the primary formatter
						return { "goimports" }
					end
					-- Final fallback
					return { "gofmt" }
				end,

				-- Python
				python = { "ruff_fix", "ruff_format" },

				-- Shell
				sh = { "shfmt" },
				bash = { "shfmt" },

				-- Misc
				["_"] = { "trim_whitespace" }, -- Apply to all filetypes
			},

			-- Format on save configuration
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
				async = false,
				quiet = false,
				filter = function(bufnr)
					-- Make sure bufnr is a number
					bufnr = tonumber(bufnr)
					if not bufnr then
						return false
					end

					-- Don't format very large files for performance reasons
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
					if ok and stats and stats.size > max_filesize then
						return false
					end

					-- Don't format readonly buffers
					if vim.bo[bufnr].readonly then
						return false
					end

					-- Don't format if we have a .noformat file in the root dir
					local root_dir = vim.fn.getcwd()
					if vim.fn.filereadable(root_dir .. "/.noformat") == 1 then
						return false
					end

					return true
				end,
			},

			-- Formatter-specific configuration
			formatters = {
				-- Customize stylua
				stylua = {
					inherit = false,
					command = "stylua",
					args = { "--indent-type", "Spaces", "--indent-width", "2", "-" },
				},

				-- Customize prettier with project-specific configuration
				prettier = {
					-- Try to find project-specific prettier config (e.g., .prettierrc)
					prepend_args = function(self, ctx)
						local args = {}

						-- Check if we have a prettier config file
						local config_file =
							vim.fs.find({ ".prettierrc", ".prettierrc.js", ".prettierrc.json", "prettier.config.js" }, {
								upward = true,
								path = ctx.dirname,
								type = "file",
							})[1]

						if config_file == nil then
							-- Default args if no config found
							args = { "--prose-wrap", "always", "--print-width", "88" }
						end

						-- Add plugin support for Astro and Svelte
						local filetype = vim.bo[ctx.buf].filetype
						if filetype == "astro" then
							table.insert(args, "--plugin")
							table.insert(args, "prettier-plugin-astro")
						elseif filetype == "svelte" then
							table.insert(args, "--plugin")
							table.insert(args, "prettier-plugin-svelte")
						end

						return args
					end,
				},

				-- Customize prettierd (faster prettier daemon)
				prettierd = {
					prepend_args = function(self, ctx)
						local args = {}

						-- Add plugin support for Astro and Svelte
						local filetype = vim.bo[ctx.buf].filetype
						if filetype == "astro" then
							table.insert(args, "--plugin")
							table.insert(args, "prettier-plugin-astro")
						elseif filetype == "svelte" then
							table.insert(args, "--plugin")
							table.insert(args, "prettier-plugin-svelte")
						end

						return args
					end,
				},

				-- Configure shfmt
				shfmt = {
					prepend_args = { "-i", "2", "-ci" }, -- 2 spaces indentation, indent case statements
				},
			},

			-- Enable the formatexpr option, for gq mapping
			formatexpr = true,

			-- Detect if project uses EditorConfig and respect its settings
			notify_on_error = true,
		},
		init = function()
			-- Set formatexpr for gq command
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},
}
