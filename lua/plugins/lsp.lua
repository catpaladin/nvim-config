return {
  -- LSP zero
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Core Dependencies
      { "williamboman/mason.nvim" },
      { 'williamboman/mason-lspconfig.nvim' },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      {
        "hrsh7th/nvim-cmp",
        dependencies = {
          "roobert/tailwindcss-colorizer-cmp.nvim",
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-buffer",
          "onsails/lspkind-nvim",
          "L3MON4D3/LuaSnip",
          "saadparwaiz1/cmp_luasnip",
        },
      },
      { "j-hui/fidget.nvim" },      -- lsp progress
      { "nvimdev/lspsaga.nvim" },   -- lsp support
      { 'stevearc/conform.nvim' },  -- format/linter on write

      -- Dev Dependencies 
      {
        "nvim-treesitter/nvim-treesitter",
        config = function()
          require("nvim-treesitter.configs").setup {
            ensure_installed = {
              "go",
              "html",
              "javascript",
              "json",
              "markdown",
              "markdown_inline",
              "python",
              "rust",
              "toml",
              "typescript",
              "tsx",
            }
          }
        end
      },
      -- code complete AI
      {
        "Exafunction/codeium.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "hrsh7th/nvim-cmp",
        },
        config = function()
          require("codeium").setup({
          })
        end
      },

      -- Language Specific
      { "folke/neodev.nvim" },                  -- lua
      {
        "ray-x/go.nvim",                        -- Go
        dependencies = {
          "ray-x/guihua.lua",
          "neovim/nvim-lspconfig",
          "nvim-treesitter/nvim-treesitter",
        },
        event = {"CmdlineEnter"},
        ft = {"go", 'gomod'},
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
      },
      { 'hashivim/vim-terraform' },             -- terraform
      { 'simrat39/rust-tools.nvim' },           -- rust
      { "jose-elias-alvarez/typescript.nvim" }, -- typescript
    },
    config = function()
      -- cmp configs
      -- Override autocompletion in this section
      -- for nvim-cmp
      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
          return false
        end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
      end
      -- And you can configure cmp even more, if you want to.
      local cmp = require('cmp')

      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              codeium = "[Codeium]",
            })[entry.source.name]
            return vim_item
          end
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'codeium' },
        }),
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
          ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end),
          ["<S-Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end),
        })
      })

      -- LSP configs
      require("fidget").setup({})
      require("lspsaga").setup({
        ui = { border = "rounded" },
        symbol_in_winbar = { enable = false },
      })

      local function on_attach(client, bufnr)
        vim.keymap.set(
          "n",
          "K",
          '<cmd>lua vim.lsp.buf.hover()<CR>',
          { buffer = bufnr, desc = "LSP hover documentation" }
        )
        vim.keymap.set(
          "n",
          "<leader>ds",
          "<Cmd>Lspsaga show_line_diagnostics<CR>",
          { buffer = bufnr, desc = "LSP show diagnostic under cursor" }
        )
        vim.keymap.set(
          "n",
          "gd",
          '<cmd>lua require"telescope.builtin".lsp_definitions{}<CR>',
          { buffer = bufnr, desc = "LSP go to definition" }
        )
        vim.keymap.set(
          "n",
          "gt",
          '<cmd>lua require"telescope.builtin".lsp_type_definitions{}<CR>',
          { buffer = bufnr, desc = "LSP go to type definition" }
        )
        vim.keymap.set(
          "n",
          "gi",
          '<cmd>lua require"telescope.builtin".lsp_implementations{}<CR>',
          { buffer = bufnr, desc = "LSP go to implementation" }
        )
        vim.keymap.set(
          "n",
          "gw",
          '<cmd>lua require"telescope.builtin".lsp_document_symbols{}<CR>',
          { buffer = bufnr, desc = "LSP document symbols" }
        )
        vim.keymap.set(
          "n",
          "gW",
          '<cmd>lua require"telescope.builtin".lsp_workspace_symbols{}<CR>',
          { buffer = bufnr, desc = "LSP Workspace symbols" }
        )
        vim.keymap.set(
          "n",
          "gr",
          '<cmd>lua require"telescope.builtin".lsp_references{}<CR>',
          { buffer = bufnr, desc = "LSP show references" }
        )
        vim.keymap.set(
          "n",
          "<leader>ca",
          '<cmd>lua require"telescope.builtin".lsp_code_actions{}<CR>',
          { buffer = bufnr, desc = "LSP show code actions" }
        )
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.preselectSupport = true
      capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
          "documentation",
          "detail",
          "additionalTextEdits",
        },
      }

      vim.diagnostic.config({
        virtual_text = {
          severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
        },
      })

      local tools = {
        "lua_ls",
        'pyright',
        'tsserver',
        "gopls",
        "black",
        "stylua",
        "prettier",
        "eslint_d",
        "terraformls",
        "yamlls",
        "rust_analyzer",
      }

      require("mason-tool-installer").setup({ ensure_installed = tools })
      require("mason").setup()
      local lsp = require("lsp-zero").preset("recommended")
      lsp.on_attach(on_attach)
      lsp.set_server_config({
        on_init = function(client)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      })

      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup(lsp.nvim_lua_ls())

      lspconfig.gopls.setup({
        on_attach = on_attach,
        flags = { debounce_text_changes = 150 },
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              unusedvariable = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
          },
        },
      })

      lspconfig.pyright.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        --before_init = function(_, config)
        --  -- Change this path to default path for poetry
        --  default_venv_path = path.join(vim.env.HOME, "virtualenvs", "nvim-venv", "bin", "python")
        --  config.settings.python.pythonPath = default_venv_path
        --end,
      }

      lspconfig.yamlls.setup({
        on_attach = on_attach,
        settings = {
          yaml = {
            validate = false,
            format = {
              enable = false,
            },
          },
        },
      })

      lsp.setup()

      require("neodev").setup({
        -- add any options here, or leave empty to use the default settings
      })

      require("go").setup({
        lsp_cfg = {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      })

      require('rust-tools').setup()

      require("typescript").setup({
        server = { on_attach = on_attach },
      })

      -- Linter/Formatter
      local cf = require("conform")
      cf.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          go = function(bufnr)
            if cf.get_formatter_info("goimports-reviser", bufnr).available then
              return { "goimports-reviser", "gofumt" }
            else
              return { "goimports", "gofmt" }
            end
          end,
          python = function(bufnr)
            if cf.get_formatter_info("ruff_format", bufnr).available then
              return { "ruff_format" }
            else
              return { "isort", "black" }
            end
          end,
          -- Use a sub-list to run only the first available formatter
          javascript = { { "prettierd", "prettier" } },
          -- Use the "*" filetype to run formatters on all filetypes.
          ["*"] = { "codespell" },
          -- Use the "_" filetype to run formatters on filetypes that don't
          -- have other formatters configured.
          ["_"] = { "trim_whitespace" },
        },
        format_on_save = {
          lsp_format = "fallback",
          timeout_ms = 500,
        },
      })
    end
  }
}
