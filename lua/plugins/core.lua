return {
  { "nvim-lua/popup.nvim" },     -- An implementation of the Popup API from vim in Neovim
  { 'rcarriga/nvim-notify' },    -- Provides popup messages
  { 'windwp/nvim-autopairs' },               -- close brackets, etc
  -- show indents
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require("ibl").setup {
        -- for example, context is off by default, use this to turn it on
      }
    end,
  },
  -- Save and load buffers (a session) automatically for each folder
  {
    'rmagatti/auto-session',
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Downloads" },
      }
    end
  },
  -- Comment code
  {
    'terrortylor/nvim-comment',
    config = function()
      require("nvim_comment").setup({ create_mappings = false })
    end
  },
  -- Git
  {
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
  -- Preview markdown live in web browser
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  -- add buffer tabs
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
        options = {
          numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
          close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
          right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
          left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
          middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
          -- NOTE: this plugin is designed with this icon in mind,
          -- and so changing this is NOT recommended, this is intended
          -- as an escape hatch for people who cannot bear it for whatever reason
          indicator = {
            icon = "▎",
            sytle = 'icon',
          },
          buffer_close_icon = "",
          -- buffer_close_icon = '',
          modified_icon = "●",
          close_icon = "",
          -- close_icon = '',
          left_trunc_marker = "",
          right_trunc_marker = "",
          max_name_length = 30,
          max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
          tab_size = 21,
          diagnostics = false, -- | "nvim_lsp" | "coc",
          diagnostics_update_in_insert = false,
          offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
          separator_style = "thin", -- | "thick" | "thin" | { 'any', 'any' },
          enforce_regular_tabs = true,
          always_show_bufferline = true,
        },
      })
		end,
	},
  { "moll/vim-bbye" }, -- used to close buffers
  -- terminal in terminal
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require("toggleterm").setup {
        -- size can be a number or function which is passed the current terminal
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true, -- hide the number column in toggleterm buffers
        shade_filetypes = {},
        shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
        shading_factor = 2, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
        start_in_insert = true,
        insert_mappings = true, -- whether or not the open mapping applies in insert mode
        terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
        persist_size = true,
        direction = 'horizontal',
        close_on_exit = true, -- close the terminal window when the process exits
        shell = vim.o.shell, -- change the default shell
        auto_scroll = true, -- automatically scroll to the bottom on terminal output
        -- This field is only relevant if direction is set to 'float'
        float_opts = {
          -- The border key is *almost* the same as 'nvim_open_win'
          -- see :h nvim_open_win for details on borders however
          -- the 'curved' border is a custom border type
          -- not natively supported but implemented in this plugin.
          border = 'curved',
          -- like `size`, width and height can be a number or function which is passed the current terminal
          winblend = 0,
          highlights = {
            border = 'Normal',
            background = 'Normal',
          },
        },
      }
    end,
  },
}
