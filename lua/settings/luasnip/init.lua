local ls = require("luasnip")
local types = require("luasnip.util.types")

ls.add_snippets("all", require("settings.luasnip.all"))
ls.add_snippets("python", require("settings.luasnip.python"))

require("luasnip.loaders.from_vscode").lazy_load()

ls.config.set_config {
  history = true,
  store_selection_keys = "<C-s>",
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,

  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "●", "GruvboxOrange" } },
      },
    },
    [types.insertNode] = {
      active = {
        virt_text = { { "●", "GruvboxBlue" } },
      },
    },
  }
}

vim.keymap.set({ "i", "s" }, "<C-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

vim.keymap.set({ "i", "s" }, "<C-h>", function()
  if ls.choice_active() then
    ls.change_choice(-1)
  end
end)
