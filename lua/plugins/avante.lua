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
      provider = "copilot",

      providers = {
        -- Ollama configuration
        ollama = {
          endpoint = "http://127.0.0.1:11434", -- No /v1 at the end
          model = "codellama:latest",
          api_key_name = "", -- Empty string for local Ollama
        },

        -- Copilot-specific configuration
        copilot = {
          model = "claude-3.7-sonnet", -- Default model
        },
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
    config = function(_, opts)
      local available_models = {
        ["claude-sonnet-4"] = { model = "claude-sonnet-4" },
        ["claude-3.7-sonnet"] = { model = "claude-3.7-sonnet" },
        ["claude-3.7-sonnet🙅‍♂️🛠️"] = { model = "claude-3.7-sonnet", disable_tools = true },
        ["claude-3.5-sonnet"] = { model = "claude-3.5-sonnet" },
        ["o3-mini-high"] = { model = "o3-mini", reasoning_effort = "high" },
        ["o4-mini-high"] = { model = "o4-mini", reasoning_effort = "high" },
        ["o4-mini-high🙅‍♂️🛠️"] = { model = "o4-mini", reasoning_effort = "high", disable_tools = true },
        ["o3-mini"] = { model = "o3-mini" },
        ["o4-mini"] = { model = "o4-mini" },
        ["4o"] = { model = "gpt-4o" },
        ["4.1"] = { model = "gpt-4.1" },
        ["4.1🙅‍♂️🛠️"] = { model = "gpt-4.1", disable_tools = true },
        ["4.1-mini"] = { model = "gpt-4.1-mini" },
        ["gemini-2.5-pro"] = { model = "gemini-2.5-pro" },
        ["gemini-2.5-pro🙅‍♂️🛠️"] = { model = "gemini-2.5-pro", disable_tools = true },
        ["gemini-2.0-flash"] = { model = "gemini-2.0-flash" },
        ["o2"] = { model = "o2" },
        ["o3"] = { model = "o3" },
        ["o1"] = { model = "o1", reasoning_effort = "high" },
      }

      local function switch_model()
        local model_keys = vim.tbl_keys(available_models)
        vim.ui.select(model_keys, { prompt = "Select Avante Model:" }, function(selected)
          if selected then
            opts.copilot = available_models[selected]
            require("avante").setup(opts)
            print("Switched Copilot model to: " .. selected)
          else
            print("Model selection canceled.")
          end
        end)
      end

      vim.keymap.set("n", "<leader>am", switch_model, { desc = "Avante: Switch Copilot Model" })

      require("avante").setup(opts)
      print("Avante.nvim configured. Use <leader>am to switch models at runtime.")
    end,
  },
}
