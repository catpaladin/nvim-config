local M = {}

--local sh_fmt = { formatCommand = 'shfmt -i 2', formatStdin = true }
--
local efm_languages = {
  python = {
    { formatCommand = 'isort -',        formatStdin = true },
    { formatCommand = 'black --fast -', formatStdin = true },
  },
  go = {
    --{ formatCommand = 'goimports-reviser -rm-unused -set-alias -format', formatStdin = true },
    --{ formatCommand = 'golines', formatStdin = true },
  },
}
--  sh = {
--    sh_fmt,
--    {
--      lintCommand = 'shellcheck -f gcc -x -',
--      lintStdin = true,
--      lintFormats = { '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m' },
--      lintSource = 'shellcheck',
--    },
--  },
--}

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
