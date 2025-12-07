local config = require("config")
if not config.lang.astro then
  return {}
end

return {
  {
    "nvim-lua/plenary.nvim",
    init = function()
      vim.filetype.add({
        extension = { astro = "astro" },
      })
    end,
  },
}
