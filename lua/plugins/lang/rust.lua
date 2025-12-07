local config = require("config")
if not config.lang.rust then
  return {}
end

return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    ft = { "rust" },
  },
}
