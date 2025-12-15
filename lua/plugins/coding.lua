local config = require("config")

local plugins = {
  -- Completion
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
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
      },
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
      },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
      snippets = { preset = "default" },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },
}

-- Codeium (optional AI completion)
if config.codeium then
  table.insert(plugins, {
    "Exafunction/codeium.nvim",
    event = "InsertEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {},
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
      { "<leader>aa", function()
        vim.cmd("ClaudeCodeDiffAccept")
        -- Close the diff buffer after accepting
        vim.defer_fn(function()
          local bufname = vim.api.nvim_buf_get_name(0)
          if bufname:match("claude%-code%-diff") or vim.bo.buftype == "nofile" then
            vim.cmd("close")
          end
        end, 100)
      end, desc = "Accept diff" },
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
      { "<leader>oo", function() require("opencode").toggle() end, desc = "Toggle OpenCode", mode = { "n", "t" } },
      { "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, desc = "Ask OpenCode", mode = { "n", "x" } },
      { "<leader>os", function() require("opencode").select() end, desc = "Select action", mode = { "n", "x" } },
      { "<leader>op", function() require("opencode").prompt("@this") end, desc = "Add to OpenCode", mode = { "n", "x" } },
      { "<leader>ob", function() require("opencode").prompt("@buffer") end, desc = "Add buffer", mode = "n" },
      { "<leader>ov", function() require("opencode").prompt("@visible") end, desc = "Add visible", mode = "n" },
      { "<leader>od", function() require("opencode").prompt("@diagnostics") end, desc = "Add diagnostics", mode = "n" },
      { "<leader>og", function() require("opencode").prompt("@diff") end, desc = "Add git diff", mode = "n" },
      { "<leader>oi", function() require("opencode").command("session.interrupt") end, desc = "Interrupt", mode = "n" },
      { "<leader>on", function() require("opencode").command("session.new") end, desc = "New session", mode = "n" },
    },
  })
end

return plugins
