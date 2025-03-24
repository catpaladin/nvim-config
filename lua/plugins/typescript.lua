return {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    ft = {
      "typescript",
      "javascript",
      "typescriptreact",
      "javascriptreact",
    },
    opts = {},
    config = function()
      require("typescript-tools").setup({
        on_attach = function(client, bufnr)
          -- Disable formatting if you prefer to use another formatter like prettier
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false

          -- Add TypeScript specific keymaps
          vim.keymap.set(
            "n",
            "<leader>to",
            ":TSToolsOrganizeImports<CR>",
            { buffer = bufnr, desc = "Organize Imports" }
          )
          vim.keymap.set(
            "n",
            "<leader>ti",
            ":TSToolsAddMissingImports<CR>",
            { buffer = bufnr, desc = "Add Missing Imports" }
          )
          vim.keymap.set("n", "<leader>tF", ":TSToolsFixAll<CR>", { buffer = bufnr, desc = "Fix All" })
          vim.keymap.set("n", "<leader>tu", ":TSToolsRemoveUnused<CR>", { buffer = bufnr, desc = "Remove Unused" })
          vim.keymap.set("n", "<leader>tR", ":TSToolsRenameFile<CR>", { buffer = bufnr, desc = "Rename File" })
          vim.keymap.set(
            "n",
            "<leader>tg",
            ":TSToolsGoToSourceDefinition<CR>",
            { buffer = bufnr, desc = "Go To Source Definition" }
          )
        end,
        settings = {
          -- Spawn a dedicated TSServer instance for better performance
          separate_diagnostic_server = true,
          -- When to publish diagnostics
          publish_diagnostic_on = "insert_leave",
          -- Expose certain features as code actions
          expose_as_code_action = {
            "fix_all",
            "add_missing_imports",
            "remove_unused",
            "organize_imports",
          },
          -- Configure TSServer settings
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
          -- Optional: Add styled components support
          tsserver_plugins = {
            -- Uncomment if you have styled-components plugin installed
            -- "@styled/typescript-styled-plugin"
          },
          -- Optional: Enable JSX closing tag support
          jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
        },
      })
    end,
  },

  -- Optional: Add ESLint for TypeScript
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    ft = {
      "typescript",
      "javascript",
      "typescriptreact",
      "javascriptreact",
    },
    config = function()
      require("lint").linters_by_ft = {
        typescript = { "eslint" },
        javascript = { "eslint" },
        typescriptreact = { "eslint" },
        javascriptreact = { "eslint" },
      }

      -- Run linter on save
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
