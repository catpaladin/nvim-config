local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local telescope = require('telescope')

--vim.api.nvim_set_keymap('n', '<leader>ff',
--  ':Telescope find_files find_command=rg,--hidden,--files theme=dropdown<CR>', {})

-- keymaps
vim.keymap.set('n', '<leader>ff',
  function()
    builtin.find_files({
      no_ignore = false,
      hidden = true
    })
  end)
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>gh', builtin.git_status, {})
vim.keymap.set('n', '<leader>ch', builtin.command_history, {})

-- This is your opts table
telescope.setup {
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
  },
  extensions = {
    ["ui-select"] = {
      theme = "dropdown",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        -- your custom insert mode mappings
        ["i"] = {
          ["<C-w>"] = function() vim.cmd('normal vbd') end,
        },
        ["n"] = {
          -- your custom normal mode mappings
          ["/"] = function()
            vim.cmd('startinsert')
          end
        },
      },
    },
  },
}
-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension("ui-select")
