local config = require("config")

local blink_providers = {
  lazydev = {
    name = "LazyDev",
    module = "lazydev.integrations.blink",
    score_offset = 100,
  },
}
local blink_sources = { "lazydev", "lsp", "path", "snippets", "buffer" }
local blink_keymap = {
  preset = "default",
  ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
  ["<C-e>"] = { "hide", "fallback" },
  ["<CR>"] = { "accept", "fallback" },
  ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
  ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
  ["<C-p>"] = { "select_prev", "fallback" },
  ["<C-n>"] = { "select_next", "fallback" },
  ["<C-b>"] = { "scroll_documentation_up", "fallback" },
  ["<C-f>"] = { "scroll_documentation_down", "fallback" },
}

-- Conditional append to blink if minuet enabled
if config.minuet.enabled then
  blink_providers.minuet = {
    name = "minuet",
    module = "minuet.blink",
    async = true,
    -- Should match minuet.config.request_timeout * 1000,
    -- since minuet.config.request_timeout is in seconds
    timeout_ms = 3000,
    score_offset = 50, -- Gives minuet higher priority among suggestions
  }
  blink_sources[#blink_sources + 1] = "minuet"
end

local plugins = {
  {
    "nvim-mini/mini.pairs",
    event = "InsertEnter",
    opts = {},
  },

  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = (function()
      local deps = { "rafamadriz/friendly-snippets" }
      if config.minuet.enabled then
        table.insert(deps, "milanglacier/minuet-ai.nvim")
      end
      return deps
    end)(),
    opts = function()
      -- Add minuet keymap if enabled (safe to require minuet here since it's a dependency)
      if config.minuet.enabled then
        blink_keymap["<A-y>"] = require("minuet").make_blink_map()
      end
      return {
        keymap = blink_keymap,
        appearance = {
          nerd_font_variant = "mono",
        },
        completion = {
          accept = { auto_brackets = { enabled = true } },
          menu = { border = "rounded" },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            window = { border = "rounded" },
          },
          trigger = { prefetch_on_insert = false },
        },
        sources = {
          default = blink_sources,
          providers = blink_providers,
        },
        snippets = { preset = "default" },
        fuzzy = { implementation = "prefer_rust_with_warning" },
      }
    end,
  },
}

-- Minuet AI (optional AI completion)
if config.minuet.enabled then
  table.insert(plugins, {
    "milanglacier/minuet-ai.nvim",
    config = function()
      require("minuet").setup({
        provider = "openai_fim_compatible",
        n_completions = 1,
        context_window = 512,
        provider_options = {
          openai_fim_compatible = {
            -- For Windows users, TERM may not be present in environment variables.
            -- Consider using APPDATA instead.
            api_key = "TERM",
            name = config.minuet.name,
            end_point = config.minuet.endpoint,
            -- The model is set by the llama-cpp server and cannot be altered
            -- post-launch.
            model = config.minuet.model,
            optional = {
              temperature = config.minuet.temperature,
              max_tokens = config.minuet.max_tokens,
              top_p = config.minuet.top_p,
              top_k = config.minuet.top_k,
            },
            -- Llama.cpp does not support the `suffix` option in FIM completion.
            -- Therefore, we must disable it and manually populate the special
            -- tokens required for FIM completion.
            template = {
              prompt = function(context_before_cursor, context_after_cursor, _)
                return "<|fim_prefix|>"
                  .. context_before_cursor
                  .. "<|fim_suffix|>"
                  .. context_after_cursor
                  .. "<|fim_middle|>"
              end,
              suffix = false,
            },
          },
        },
      })
    end,
  })
end

-- Cursortab (optional local AI completion)
if config.cursortab.enabled then
  table.insert(plugins, {
    "leonardcser/cursortab.nvim",
    build = "cd server && go build",
    config = function()
      require("cursortab").setup({
        enabled = true,
        log_level = "info", -- "trace", "debug", "info", "warn", "error"

        ui = {
          colors = {
            deletion = "#4f2f2f", -- Background color for deletions
            addition = "#394f2f", -- Background color for additions
            modification = "#282e38", -- Background color for modifications
            completion = "#80899c", -- Foreground color for completions
          },
          jump = {
            symbol = "", -- Symbol shown for jump points
            text = " TAB ", -- Text displayed after jump symbol
            show_distance = true, -- Show line distance for off-screen jumps
            bg_color = "#373b45", -- Jump text background color
            fg_color = "#bac1d1", -- Jump text foreground color
          },
        },

        behavior = {
          idle_completion_delay = 50, -- Delay in ms after idle to trigger completion (-1 to disable)
          text_change_debounce = 50, -- Debounce in ms after text change to trigger completion
          cursor_prediction = {
            enabled = true, -- Show jump indicators after completions
            auto_advance = true, -- When no changes, show cursor jump to last line
            proximity_threshold = 2, -- Min lines apart to show cursor jump (0 to disable)
          },
        },

        provider = {
          type = config.cursortab.provider, -- Provider: "inline", "fim", "sweep", or "zeta"
          url = config.cursortab.provider_url, -- URL of the provider server
          model = config.cursortab.provider_model, -- Model name
          temperature = config.cursortab.provider_temperature, -- Sampling temperature
          max_tokens = config.cursortab.provider_max_tokens, -- Max tokens to generate
          top_k = config.cursortab.provider_top_k, -- Top-k sampling
          completion_timeout = 5000, -- Timeout in ms for completion requests
          max_diff_history_tokens = 512, -- Max tokens for diff history (0 = no limit)
          completion_path = "/v1/completions", -- API endpoint path
        },

        debug = {
          immediate_shutdown = true, -- Shutdown daemon immediately when no clients
        },
      })
    end,
  })
end

-- Claude Code (optional CLI integration)
if config.claudecode then
  table.insert(plugins, {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      terminal_cmd = config.paths.claude_cli,
    },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>aa",
        function()
          vim.cmd("ClaudeCodeDiffAccept")
          -- Close the diff buffer after accepting
          vim.defer_fn(function()
            local bufname = vim.api.nvim_buf_get_name(0)
            if bufname:match("claude%-code%-diff") or vim.bo.buftype == "nofile" then
              vim.cmd("close")
            end
          end, 100)
        end,
        desc = "Accept diff",
      },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  })
end

-- OpenCode (optional AI assistant integration)
if config.opencode then
  table.insert(plugins, {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      vim.g.opencode_opts = {}
      vim.o.autoread = true
    end,
    keys = {
      { "<leader>o", nil, desc = "OpenCode" },
      {
        "<leader>oo",
        function()
          require("opencode").toggle()
        end,
        desc = "Toggle OpenCode",
        mode = { "n", "t" },
      },
      {
        "<leader>oa",
        function()
          require("opencode").ask("@this: ", { submit = true })
        end,
        desc = "Ask OpenCode",
        mode = { "n", "x" },
      },
      {
        "<leader>os",
        function()
          require("opencode").select()
        end,
        desc = "Select action",
        mode = { "n", "x" },
      },
      {
        "<leader>op",
        function()
          require("opencode").prompt("@this")
        end,
        desc = "Add to OpenCode",
        mode = { "n", "x" },
      },
      {
        "<leader>ob",
        function()
          require("opencode").prompt("@buffer")
        end,
        desc = "Add buffer",
        mode = "n",
      },
      {
        "<leader>ov",
        function()
          require("opencode").prompt("@visible")
        end,
        desc = "Add visible",
        mode = "n",
      },
      {
        "<leader>od",
        function()
          require("opencode").prompt("@diagnostics")
        end,
        desc = "Add diagnostics",
        mode = "n",
      },
      {
        "<leader>og",
        function()
          require("opencode").prompt("@diff")
        end,
        desc = "Add git diff",
        mode = "n",
      },
      {
        "<leader>oi",
        function()
          require("opencode").command("session.interrupt")
        end,
        desc = "Interrupt",
        mode = "n",
      },
      {
        "<leader>on",
        function()
          require("opencode").command("session.new")
        end,
        desc = "New session",
        mode = "n",
      },
    },
  })
end

return plugins
