--vim.api.nvim.command("set runtimepath^=~/.vim runtimepath+=~/.vim/after")
--vim.api.nvim.command("let &packpath = &runtimepath")
-- load old configs (for now)
--vim.api.nvim_command("source $HOME/.vimrc")

require("plugins")
require("keymaps")
require("options")
require("setups")

-- load plug configs
for i, vf in pairs(vim.split(vim.fn.glob('$HOME/.config/nvim/plug-config/*.vim'), '\n')) do
  vim.api.nvim_command('source ' .. vf)
end
