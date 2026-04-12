local config = require("config")
if not config.lang.go then
  return {}
end

return {
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod", "gosum", "gotmpl", "gohtmltmpl", "gowork" },
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
    },
    build = ':lua require("go.install").update_all_sync()',
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      require("go").setup({
        lsp_cfg = {
          capabilities = capabilities,
          settings = {
            gopls = {
              usePlaceholders = true,
              completeUnimported = true,
              analyses = { unusedparams = true, shadow = true },
              staticcheck = true,
              gofumpt = true,
            },
          },
        },
        lsp_on_attach = function(_, bufnr)
          require("keymaps").setup_lsp_keymaps(bufnr)

          -- Go-specific keymaps
          local opts = { buffer = bufnr, silent = true }
          vim.keymap.set("n", "<leader>gt", ":GoTest<CR>", vim.tbl_extend("force", opts, { desc = "Go Test" }))
          vim.keymap.set("n", "<leader>gtf", ":GoTestFunc<CR>", vim.tbl_extend("force", opts, { desc = "Go Test Function" }))
          vim.keymap.set("n", "<leader>gc", ":GoCoverage<CR>", vim.tbl_extend("force", opts, { desc = "Go Coverage" }))
          vim.keymap.set("n", "<leader>gi", ":GoImport ", vim.tbl_extend("force", opts, { desc = "Go Import" }))
          vim.keymap.set("n", "<leader>gfs", ":GoFillStruct<CR>", vim.tbl_extend("force", opts, { desc = "Go Fill Struct" }))
          vim.keymap.set("n", "<leader>gif", ":GoIfErr<CR>", vim.tbl_extend("force", opts, { desc = "Go If Err" }))
          vim.keymap.set("n", "<leader>gat", ":GoAddTag ", vim.tbl_extend("force", opts, { desc = "Go Add Tags" }))
          vim.keymap.set("n", "<leader>grm", ":GoRmTag<CR>", vim.tbl_extend("force", opts, { desc = "Go Remove Tags" }))
        end,
        goimports = "gofumpt",
        fillstruct = "gopls",
        test_flags = { "-v" },
        test_runner = "go",
        diagnostic = {
          hdlr = true,
          underline = true,
          virtual_text = { space = 0, prefix = "●" },
          signs = true,
        },
        trouble = true,
        lsp_document_formatting = false,
        lsp_inlay_hints = {
          enable = true,
          show_parameter_hints = true,
          show_variable_name = true,
        },
      })
    end,
  },
}
