return {
  {
    "nvim-lua/plenary.nvim",
    init = function()
      vim.filetype.add({
        extension = {
          astro = "html",
        },
      })
    end,
  },
  -- Astro language server
  {
    "withastro/language-tools",
    lazy = true,
    ft = "html",
    config = function()
      require("lspconfig").astro.setup({
        filetypes = { "html" },
      })
    end,
  },
}

