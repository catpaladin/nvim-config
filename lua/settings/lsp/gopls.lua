local M = {}

local utils = require("settings.lsp.utils")

function M.config()
  return {
    on_attach = utils.lsp_attach,
    capabilities = utils.get_capabilities(),
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
  }
end

function M.setup()
  require('go').setup({
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

  return M.config()
end

return M
