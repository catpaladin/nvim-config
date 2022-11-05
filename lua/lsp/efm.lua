local M = {}

local sh_fmt = { formatCommand = 'shfmt -i 2', formatStdin = true }

local efm_languages = {
  python = {
    { formatCommand = 'isort -', formatStdin = true },
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
}

function M.setup(on_attach, lsp_flags, capabilities)
  require('lspconfig').efm.setup({
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    init_options = { documentFormatting = true },
    filetypes = vim.tbl_keys(efm_languages),
    settings = { rootMarkers = { '.git/' }, languages = efm_languages },
  })
end

return M
