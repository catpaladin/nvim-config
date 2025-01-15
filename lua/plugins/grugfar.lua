return {
  {
    "MagicDuck/grug-far.nvim",
    -- Load when using the command
    cmd = { "GrugFar" },
    -- Keymaps for quick access
    keys = {
      { "<leader>fr", "<cmd>GrugFar<cr>", desc = "Find and Replace" },
    },
    opts = {
      -- Use ripgrep if available (much faster)
      use_rg = vim.fn.executable("rg") == 1,

      -- Pattern to ignore (similar to ripgrep)
      ignore_patterns = {
        "%.git/",
        "node_modules/",
        "%.cache/",
        "build/",
        "dist/",
      },

      -- Default options
      default_options = {
        confirm_replace = true, -- Ask for confirmation before replacing
        match_case = false, -- Case insensitive by default
        whole_word = false, -- Don't match whole words by default
        use_regex = false, -- Don't use regex by default
      },
    },
    -- Optional: add highlights for better visibility
    config = function(_, opts)
      require("grug-far").setup(opts)

      -- Set highlighting for matches
      vim.api.nvim_set_hl(0, "GrugFarMatch", { fg = "yellow", bold = true })
      vim.api.nvim_set_hl(0, "GrugFarReplace", { fg = "green", bold = true })
    end,
  },
}
