local config = require("config")

-- Build mason tools list based on enabled languages
local tools = {
  "lua_ls",
  "stylua",
  "prettier",
  "prettierd",
}

if config.lang.python then
  vim.list_extend(tools, { "ty", "black", "ruff" })
end
if config.lang.go then
  table.insert(tools, "gopls")
end
if config.lang.typescript then
  vim.list_extend(tools, { "eslint_d" })
end
if config.lang.astro then
  table.insert(tools, "astro-language-server")
end

return {
  -- Mason (package manager for LSP servers, formatters, linters)
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {},
  },
  { "williamboman/mason-lspconfig.nvim", opts = {} },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = { ensure_installed = tools },
  },

  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
      { "j-hui/fidget.nvim", opts = {} },
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- LspAttach autocmd for keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then
            client.server_capabilities.semanticTokensProvider = nil
          end
          require("keymaps").setup_lsp_keymaps(args.buf)
        end,
      })

      -- Server configurations
      local servers = {
        lua_ls = {
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = { checkThirdParty = false },
              completion = { callSnippet = "Replace" },
              telemetry = { enable = false },
            },
          },
        },
        yamlls = {
          capabilities = capabilities,
          settings = {
            yaml = { validate = false, format = { enable = false } },
          },
        },
        ty = {
          capabilities = capabilities,
          settings = {
            configuration = {
              rules = {
                ["unresolved-reference"] = "warn"
              }
            },
          }
        },
        ruff = {
          capabilities = capabilities,
          init_options = {
            settings = {
              lint = {
                select = { "E", "F", "I", "W", "UP" },
              },
            },
          },
        },
      }

      -- Add Astro LSP if enabled
      if config.lang.astro then
        servers.astro = {
          capabilities = capabilities,
          init_options = {
            configuration = {
              typescript = {
                tsdk = vim.fn.expand(config.paths.typescript_sdk),
              },
            },
          },
        }
      end

      -- Enable servers
      for server, cfg in pairs(servers) do
        vim.lsp.config(server, cfg)
        vim.lsp.enable(server)
      end

      -- Diagnostics config
      vim.diagnostic.config({
        virtual_text = {
          severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
        },
      })
    end,
  },
}
