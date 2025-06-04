return {
  {
    "nvim-lua/popup.nvim",
    lazy = true,
    event = "VeryLazy",
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      vim.notify = require("notify")
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true, -- Enable treesitter
      ts_config = {
        lua = { "string" }, -- Don't add pairs in lua string treesitter nodes
        javascript = { "template_string" }, -- Don't add pairs in javscript template_string
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = true },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },
  {
    "terrortylor/nvim-comment",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim_comment").setup({
        create_mappings = false,
        -- Hook to better integration with treesitter
        hook = function()
          if vim.bo.filetype == "vue" then
            require("ts_context_commentstring.internal").update_commentstring()
          end
        end,
      })
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = {
      "MarkdownPreviewToggle",
      "MarkdownPreview",
      "MarkdownPreviewStop",
    },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_echo_preview_url = 1
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        mode = "buffers",
        separator_style = "slant",
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        color_icons = true,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_terminals = true,
      insert_mappings = true,
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      -- Define keymaps for multiple numbered terminals
      local function set_terminal_keymaps()
        for i = 1, 9 do
          vim.keymap.set({ "n", "t" }, string.format("<leader>t%d", i), function()
            require("toggleterm").toggle(i, nil, nil, "horizontal")
          end, { desc = string.format("Toggle Terminal %d", i) })

          vim.keymap.set({ "n", "t" }, string.format("<leader>v%d", i), function()
            require("toggleterm").toggle(i, nil, nil, "vertical")
          end, { desc = string.format("Toggle Vertical Terminal %d", i) })

          vim.keymap.set({ "n", "t" }, string.format("<leader>f%d", i), function()
            require("toggleterm").toggle(i, nil, nil, "float")
          end, { desc = string.format("Toggle Floating Terminal %d", i) })
        end
      end
      set_terminal_keymaps()
    end,
  },
}
