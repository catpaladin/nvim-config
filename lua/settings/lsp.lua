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
require("lspsaga").setup({
  ui = { border = "rounded" },
  symbol_in_winbar = { enable = false },
})

local function on_attach(client, bufnr)
  vim.keymap.set(
    "n",
    "gd",
    "<Cmd>Lspsaga goto_definition<CR>",
    { buffer = bufnr, desc = "LSP go to definition" }
  )
  vim.keymap.set(
    "n",
    "gt",
    "<Cmd>Lspsaga peek_type_definition<CR>",
    { buffer = bufnr, desc = "LSP go to type definition" }
  )
  vim.keymap.set(
    "n",
    "gD",
    "<Cmd>lua vim.lsp.buf.declaration()<CR>",
    { buffer = bufnr, desc = "LSP go to declaration" }
  )
  vim.keymap.set(
    "n",
    "gi",
    "<Cmd>lua vim.lsp.buf.implementation()<CR>",
    { buffer = bufnr, desc = "LSP go to implementation" }
  )
  vim.keymap.set("n", "gw", "<Cmd>Lspsaga lsp_finder<CR>", { buffer = bufnr, desc = "LSP document symbols" })
  vim.keymap.set(
    "n",
    "gW",
    "<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>",
    { buffer = bufnr, desc = "LSP Workspace symbols" }
  )
  vim.keymap.set(
    "n",
    "gr",
    "<Cmd>lua vim.lsp.buf.references()<CR>",
    { buffer = bufnr, desc = "LSP show references" }
  )
  vim.keymap.set("n", "K", "<Cmd>Lspsaga hover_doc<CR>", { buffer = bufnr, desc = "LSP hover documentation" })
  vim.keymap.set(
    "n",
    "<c-k>",
    "<Cmd>lua vim.lsp.buf.signature_help()<CR>",
    { buffer = bufnr, desc = "LSP signature help" }
  )
  vim.keymap.set(
    "n",
    "<leader>af",
    "<Cmd>Lspsaga code_action<CR>",
    { buffer = bufnr, desc = "LSP show code actions" }
  )
  vim.keymap.set("n", "<leader>rn", "<Cmd>Lspsaga rename<CR>", { buffer = bufnr, desc = "LSP rename word" })
  vim.keymap.set(
    "n",
    "<leader>dn",
    "<Cmd>Lspsaga diagnostic_jump_next<CR>",
    { buffer = bufnr, desc = "LSP go to next diagnostic" }
  )
  vim.keymap.set(
    "n",
    "<leader>dp",
    "<Cmd>Lspsaga diagnostic_jump_prev<CR>",
    { buffer = bufnr, desc = "LSP go to previous diagnostic" }
  )
  vim.keymap.set(
    "n",
    "<leader>ds",
    "<Cmd>Lspsaga show_line_diagnostics<CR>",
    { buffer = bufnr, desc = "LSP show diagnostic under cursor" }
  )

  -- Register formatting and autoformatting
  -- based on lsp server
  local supported_clients = {
    gopls = true,
    pylsp = true,
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
  single_file_support = false,
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
