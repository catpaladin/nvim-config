local M = {}

function M.setup(on_attach, lsp_flags, capabilities)
  local luadev = require('lua-dev').setup({
    lspconfig = {
      on_attach = on_attach,
      flags = lsp_flags,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
        },
      },
    },
  })
  require('lspconfig')['sumneko_lua'].setup(luadev)
end

return M
