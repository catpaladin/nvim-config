local M = {}

local sh_fmt = { formatCommand = 'shfmt -i 2', formatStdin = true }

local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" },
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
}

local efm_languages = {
  python = {
    { formatCommand = 'isort -',        formatStdin = true },
    { formatCommand = 'black --fast -', formatStdin = true },
  },
  sh = {
    sh_fmt,
    {
      lintCommand = 'shellcheck -f gcc -x -',
      lintStdin = true,
      lintFormats = { '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m' },
      lintSource = 'shellcheck',
    },
  },
  go = {
    { formatCommand = 'goimports-reviser -rm-unused -set-alias -format -', formatStdin = true },
    { formatCommand = 'golines -',                                         formatStdin = true },
  },
  javascript = { eslint },
  javascriptreact = { eslint },
  ["javascript.jsx"] = { eslint },
  typescript = { eslint },
  ["typescript.tsx"] = { eslint },
  typescriptreact = { eslint },
}

local utils = require("settings.lsp.utils")

function M.config()
  return {
    on_attach = utils.lsp_attach,
    capabilities = utils.get_capabilities(),
    flags = { debounce_text_changes = 150 },
    init_options = { documentFormatting = true },
    filetypes = vim.tbl_keys(efm_languages),
    settings = { rootMarkers = { '.git/' }, languages = efm_languages },
  }
end

function M.setup()
  return M.config()
end

return M
