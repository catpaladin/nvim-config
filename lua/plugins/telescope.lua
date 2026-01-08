return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      -- Basic file and text search
      { "<leader>p", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Search in files" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Search help" },
      -- Search word under cursor
      {
        "<leader>fw",
        function()
          require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })
        end,
        desc = "Search current word",
      },
      -- Search in neovim config
      {
        "<leader>fd",
        function()
          require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Search in config",
      },
    },
    opts = {
      defaults = {
        path_display = { "truncate" },
        layout_config = {
          width = 0.75,
          height = 0.75,
          prompt_position = "top",
        },
        file_ignore_patterns = {
          "node_modules/",
          ".git/",
        },
        mappings = {
          i = {
            ["<esc>"] = "close",
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          no_ignore = true,
        },
        live_grep = {
          hidden = true,
          no_ignore = true,
        },
      },
    },
  },
}
