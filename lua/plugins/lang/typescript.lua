local config = require("config")
if not config.lang.typescript then
  return {}
end

return {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    config = function()
      require("typescript-tools").setup({
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false

          -- TypeScript-specific keymaps
          local opts = { buffer = bufnr }
          vim.keymap.set("n", "<leader>to", ":TSToolsOrganizeImports<CR>", vim.tbl_extend("force", opts, { desc = "Organize Imports" }))
          vim.keymap.set("n", "<leader>ti", ":TSToolsAddMissingImports<CR>", vim.tbl_extend("force", opts, { desc = "Add Missing Imports" }))
          vim.keymap.set("n", "<leader>tF", ":TSToolsFixAll<CR>", vim.tbl_extend("force", opts, { desc = "Fix All" }))
          vim.keymap.set("n", "<leader>tu", ":TSToolsRemoveUnused<CR>", vim.tbl_extend("force", opts, { desc = "Remove Unused" }))
          vim.keymap.set("n", "<leader>tR", ":TSToolsRenameFile<CR>", vim.tbl_extend("force", opts, { desc = "Rename File" }))
          vim.keymap.set("n", "<leader>tg", ":TSToolsGoToSourceDefinition<CR>", vim.tbl_extend("force", opts, { desc = "Go To Source Definition" }))
        end,
        settings = {
          separate_diagnostic_server = true,
          publish_diagnostic_on = "insert_leave",
          expose_as_code_action = { "fix_all", "add_missing_imports", "remove_unused", "organize_imports" },
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
          jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
        },
      })
    end,
  },

  -- ESLint
  {
    "mfussenegger/nvim-lint",
    ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    config = function()
      require("lint").linters_by_ft = {
        typescript = { "eslint" },
        javascript = { "eslint" },
        typescriptreact = { "eslint" },
        javascriptreact = { "eslint" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
