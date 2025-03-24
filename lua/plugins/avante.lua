-- lua/plugins/avante.lua
return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim", -- Make sure this is included
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua", -- This might be needed for message parsing
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    opts = {
      provider = "ollama",

      -- Ollama configuration
      ollama = {
        endpoint = "http://127.0.0.1:11434", -- No /v1 at the end
        model = "codellama:latest",
        api_key_name = "", -- Empty string for local Ollama
      },

      -- Copilot-specific configuration
      copilot = {
        model = "gpt-4o",
      },

      -- Additional behavior settings
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = true,
      },

      -- Enable cursor planning mode (recommended for Ollama)
      cursor_planning_mode = true,

      -- Make sure paths are handled correctly
      use_absolute_path = true,

      -- Mappings
      mappings = {
        ask = "<leader>aa",
        edit = "<leader>ae",
        refresh = "<leader>ar",
      },
    },
  },
}
