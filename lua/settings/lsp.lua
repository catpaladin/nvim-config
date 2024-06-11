-- Setup functions and options to be used further down
local format_group = vim.api.nvim_create_augroup("LspFormatGroup", {})
local format_opts = { async = false, timeout_ms = 2500 }

local function register_fmt_keymap(name, bufnr)
  local fmt_keymap = "<leader>f"
  vim.keymap.set("n", fmt_keymap, function()
    vim.lsp.buf.format(vim.tbl_extend("force", format_opts, { name = name, bufnr = bufnr }))
  end, { desc = "Format current buffer [LSP]", buffer = bufnr })
end

local function register_fmt_autosave(name, bufnr)
  vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = format_group,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format(vim.tbl_extend("force", format_opts, { name = name, bufnr = bufnr }))
    end,
    desc = "Format on save [LSP]",
  })
end

require("fidget").setup({})

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
    '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
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

  -- Register formatting and autoformatting
  -- based on lsp server
  local supported_clients = {
    gopls = true,
    pylsp = true,
    terraformls = true,
    tsserver = true,
  }

  if supported_clients[client.name] then
    register_fmt_keymap(client.name, bufnr)
    register_fmt_autosave(client.name, bufnr)
  end
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

-- List out the lsp servers, linters, formatters
-- for mason
local tools = {
  "lua_ls",
  "typescript-language-server",
  "gopls",
  "python-lsp-server",
  "black",
  "stylua",
  "prettier",
  "eslint_d",
  "terraformls",
  "yamlls",
  "rust_analyzer",
}

require("mason-tool-installer").setup({ ensure_installed = tools })

-- Register lsp servers
-- if they depend on an extra plugin (eg go.nvim)
-- then call those in this section
require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})

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

lspconfig.pylsp.setup({
  on_attach = on_attach,
  single_file_support = true,
  settings = {
    pylsp = {
      plugins = {
        -- formatter options
        black = { enabled = true },
        -- type checker
        pylsp_mypy = { enabled = true },
        -- import sorting
        pyls_isort = { enabled = true },
      },
    },
  },
})

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

require("typescript").setup({
  server = { on_attach = on_attach },
})

require("go").setup({
  -- notify: use nvim-notify
  notify = true,
  -- auto commands
  auto_format = true,
  auto_lint = true,
  -- linters: revive, errcheck, staticcheck, golangci-lint
  linter = 'golangci-lint',
  -- linter_flags: e.g., {revive = {'-config', '/path/to/config.yml'}}
  linter_flags = {},
  -- lint_prompt_style: qf (quickfix), vt (virtual text)
  lint_prompt_style = 'qf',
  -- formatter: goimports, gofmt, gofumpt
  formatter = 'gofumpt',
  -- maintain cursor position after formatting loaded buffer
  maintain_cursor_pos = false,
  -- test flags: -count=1 will disable cache
  test_flags = { '-v' },
  test_timeout = '30s',
  test_env = {},
  -- show test result with popup window
  test_popup = true,
  test_popup_auto_leave = false,
  test_popup_width = 80,
  test_popup_height = 10,
  -- test open
  test_open_cmd = 'edit',
  -- struct tags
  tags_name = 'json',
  tags_options = { 'json=omitempty' },
  tags_transform = 'snakecase',
  tags_flags = { '-skip-unexported' },
  -- quick type
  quick_type_flags = { '--just-types' },
})

require('rust-tools').setup()

lsp.setup()

-- Linter/Formatter
local formatters = require("formatter")
formatters.setup({
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    python = {
      function()
        return {
          exe = "isort",
          args = {
            "--quiet",
            "-",
          },
          stdin = true
        }
      end,
      function()
        return {
          exe = "black",
          args = {
            "--fast",
            "-",
          },
          stdin = true
        }
      end,
    },
    go = {
      function()
        return {
          exe = "golines",
          args = {
            "-",
          },
          stdin = true
        }
      end,
      function()
        return {
          exe = "goimports-reviser",
          args = {
            "-imports-order",
            "std,general,company,project,blanked,dotted",
            "-rm-unused",
            "-set-alias",
            "-format",
            "-",
          },
          stdin = true
        }
      end,
    },
    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
})
