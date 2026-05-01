local config = require("config")

local parsers = {
  "lua",
  "bash",
  "html",
  "json",
  "toml",
  "yaml",
  "markdown",
  "markdown_inline",
  "regex",
  "query",
  "vimdoc",
  "vim",
  "css",
  "svelte",
}

if config.lang.python then
  table.insert(parsers, "python")
end
if config.lang.go then
  table.insert(parsers, "go")
end
if config.lang.typescript then
  vim.list_extend(parsers, { "typescript", "javascript" })
end
if config.lang.rust then
  table.insert(parsers, "rust")
end
if config.lang.astro then
  table.insert(parsers, "astro")
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(parsers):wait(300000)
    end,
  },
}
