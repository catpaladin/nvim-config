return {
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod", "gosum", "gotmpl", "gohtmltmpl", "gowork" },
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    build = ':lua require("go.install").update_all_sync()',
    config = function()
      -- Create utility for path detection
      local util = {}
      function util.path_exists(path)
        local file = io.open(path, "r")
        if file then
          file:close()
          return true
        end
        return false
      end

      -- Setup capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem = {
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        resolveSupport = {
          properties = { "documentation", "detail", "additionalTextEdits" },
        },
      }

      require("go").setup({
        -- Setup gopls with non-default configurations
        lsp_cfg = {
          capabilities = capabilities,
          settings = {
            gopls = {
              usePlaceholders = true,
              completeUnimported = true,
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              gofumpt = true,
            },
          },
        },
        -- Attach keymaps and LSP config when gopls attaches
        lsp_on_attach = function(client, bufnr)
          -- Use common LSP keymaps
          require("config.keymaps").setup_lsp_keymaps(bufnr)

          -- Add Go-specific keymaps
          local opts = { buffer = bufnr, silent = true }
          vim.keymap.set("n", "<leader>gt", ":GoTest<CR>", vim.tbl_extend("force", opts, { desc = "Go Test" }))
          vim.keymap.set(
            "n",
            "<leader>gtf",
            ":GoTestFunc<CR>",
            vim.tbl_extend("force", opts, { desc = "Go Test Function" })
          )
          vim.keymap.set("n", "<leader>gc", ":GoCoverage<CR>", vim.tbl_extend("force", opts, { desc = "Go Coverage" }))
          vim.keymap.set("n", "<leader>gi", ":GoImport ", vim.tbl_extend("force", opts, { desc = "Go Import" }))
          vim.keymap.set(
            "n",
            "<leader>gfs",
            ":GoFillStruct<CR>",
            vim.tbl_extend("force", opts, { desc = "Go Fill Struct" })
          )
          vim.keymap.set("n", "<leader>gif", ":GoIfErr<CR>", vim.tbl_extend("force", opts, { desc = "Go If Err" }))
          vim.keymap.set("n", "<leader>gat", ":GoAddTag ", vim.tbl_extend("force", opts, { desc = "Go Add Tags" }))
          vim.keymap.set("n", "<leader>grm", ":GoRmTag<CR>", vim.tbl_extend("force", opts, { desc = "Go Remove Tags" }))
        end,

        -- Configure goimports to use gofumpt formatting
        goimports = "gofumpt",

        -- Set up fillstruct
        fillstruct = "gopls",

        -- Configure test flags
        test_flags = { "-v" },

        -- Configure test runner
        test_runner = "go",

        -- Configure diagnostics
        diagnostic = {
          hdlr = true,
          underline = true,
          virtual_text = { space = 0, prefix = "●" },
          signs = true,
        },

        -- Configure trouble integration (if available)
        trouble = true,

        -- Disable lsp formatting as we'll use conform.nvim
        lsp_document_formatting = false,

        -- Configure inlay hints for Neovim 0.10+
        lsp_inlay_hints = {
          enable = true,
          show_parameter_hints = true,
          show_variable_name = true,
          show_parameter_types = true,
          only_current_line = false,
        },
      })
    end,
  },
}
