return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter").install({
        "astro",
        "bash",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "rust",
        "svelte",
        "toml",
        "typescript",
        "tsx",
        "yaml",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "astro",
          "bash",
          "go",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "python",
          "rust",
          "svelte",
          "toml",
          "typescript",
          "tsx",
          "yaml",
        },
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
}

