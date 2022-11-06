-- requires
require("plugins")
require("keymaps")
require("options")
require("settings")

-- load plug configs
for _, vf in pairs(vim.split(vim.fn.glob('$HOME/.config/nvim/plug-config/*.vim'), '\n')) do
  vim.api.nvim_command('source ' .. vf)
end
