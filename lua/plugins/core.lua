return {
  { "nvim-lua/popup.nvim" }, -- An implementation of the Popup API from vim in Neovim
  { "rcarriga/nvim-notify" }, -- Provides popup messages
  { "windwp/nvim-autopairs" }, -- close brackets, etc
  -- show indents
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup({
        -- for example, context is off by default, use this to turn it on
      })
    end,
  },
  -- Comment code
  {
    "terrortylor/nvim-comment",
    config = function()
      require("nvim_comment").setup({ create_mappings = false })
    end,
  },
  -- Preview markdown live in web browser
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  -- add buffer tabs
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({})
    end,
  },
  { "akinsho/toggleterm.nvim" }, -- terminal in terminal
}
