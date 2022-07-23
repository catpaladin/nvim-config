-- requires
require("plugins")
require("keymaps")
require("options")
require("setups")
require("lsp")

-- load plug configs
for _, vf in pairs(vim.split(vim.fn.glob('$HOME/.config/nvim/plug-config/*.vim'), '\n')) do
  vim.api.nvim_command('source ' .. vf)
end

-- set color scheme
--vim.api.nvim_command('colorscheme dracula')
vim.api.nvim_command('colorscheme terafox')
