return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    lazy = true,
    config = false,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" }, -- Load only when buffer is opened
    dependencies = {
      -- Core Dependencies (lazy-loaded)
      {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
      },
      { "williamboman/mason-lspconfig.nvim" },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter", -- Load completion only in insert mode
        dependencies = {
          { "roobert/tailwindcss-colorizer-cmp.nvim", lazy = true },
          { "hrsh7th/cmp-nvim-lsp", lazy = true },
          { "hrsh7th/cmp-path", lazy = true },
          { "hrsh7th/cmp-buffer", lazy = true },
          { "onsails/lspkind-nvim", lazy = true },
          { "L3MON4D3/LuaSnip", lazy = true },
          { "saadparwaiz1/cmp_luasnip", lazy = true },
        },
      },
      {
        "j-hui/fidget.nvim",
        event = "LspAttach",
      },
      {
        "nvimdev/lspsaga.nvim",
        event = "LspAttach",
      },
      {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
      },
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
          require("nvim-treesitter.configs").setup({
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
              "lua",
            },
            sync_install = false,
            auto_install = true,
            highlight = { enable = true },
          })
        end,
      },
      -- Language Specific (lazy-loaded by filetype)
      {
        "folke/neodev.nvim",
        ft = "lua",
      },
      {
        "simrat39/rust-tools.nvim",
        ft = "rust",
      },
    },
    config = function()
      -- Load utility functions
      local util = {}

      function util.path_exists(path)
        local file = io.open(path, "r")
        if file then
          file:close()
          return true
        end
        return false
      end

      function util.get_python_path()
        local venv_path = vim.fn.getcwd() .. "/.venv/bin/python"
        return util.path_exists(venv_path) and venv_path or nil
      end

      -- Setup nvim-cmp
      local cmp = require("cmp")
      local has_words_before = function()
        if vim.bo.buftype == "prompt" then
          return false
        end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
      end

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
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "codeium" },
        }),
        mapping = require("config.keymaps").get_cmp_mappings(cmp, has_words_before),
      })

      -- LSP Setup
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem = {
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        resolveSupport = {
          properties = { "documentation", "detail", "additionalTextEdits" },
        },
      }

      -- Configure LSP servers
      local lspconfig = require("lspconfig")
      local lsp = require("lsp-zero").preset("recommended")

      -- Set up Mason
      local tools = {
        "lua_ls",
        "pyright",
        "gopls",
        "black",
        "stylua",
        "prettier",
        "eslint_d",
        "terraformls",
        "yamlls",
        "rust_analyzer",
        "typescript-language-server",
      }

      require("mason-tool-installer").setup({ ensure_installed = tools })
      require("mason").setup()

      -- Common LSP configurations
      lsp.on_attach(function(client, bufnr)
        require("config.keymaps").setup_lsp_keymaps(bufnr)
      end)
      lsp.set_server_config({
        on_init = function(client)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      })

      -- Server-specific configurations
      local servers = {
        lua_ls = lsp.nvim_lua_ls(),
        pyright = {
          capabilities = capabilities,
          before_init = function(_, config)
            local python_path = util.get_python_path()
            if python_path then
              config.settings.python.pythonPath = python_path
            end
          end,
        },
        yamlls = {
          settings = {
            yaml = {
              validate = false,
              format = { enable = false },
            },
          },
        },
        tsserver = {
          capabilities = capabilities,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
      }

      -- Set up each LSP server
      for server, config in pairs(servers) do
        lspconfig[server].setup(config)
      end

      lsp.setup()

      -- Additional tool configurations
      require("neodev").setup({})
      require("rust-tools").setup()
      require("fidget").setup({})
      require("lspsaga").setup({
        ui = { border = "rounded" },
        symbol_in_winbar = { enable = false },
      })

      -- Set up diagnostics
      vim.diagnostic.config({
        virtual_text = {
          severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
        },
      })
    end,
  },
}
