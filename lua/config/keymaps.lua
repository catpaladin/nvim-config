local M = {}

-- LSP keymaps setup function
function M.setup_lsp_keymaps(bufnr)
  local opts = { buffer = bufnr }
  -- Document navigation and information
  vim.keymap.set(
    "n",
    "K",
    "<cmd>lua vim.lsp.buf.hover()<CR>",
    vim.tbl_extend("force", opts, { desc = "LSP hover documentation" })
  )
  vim.keymap.set(
    "n",
    "<leader>ds",
    "<Cmd>Lspsaga show_line_diagnostics<CR>",
    vim.tbl_extend("force", opts, { desc = "LSP show diagnostic under cursor" })
  )

  -- Definition and references
  vim.keymap.set(
    "n",
    "gd",
    '<cmd>lua require"telescope.builtin".lsp_definitions{}<CR>',
    vim.tbl_extend("force", opts, { desc = "LSP go to definition" })
  )
  vim.keymap.set(
    "n",
    "gt",
    '<cmd>lua require"telescope.builtin".lsp_type_definitions{}<CR>',
    vim.tbl_extend("force", opts, { desc = "LSP go to type definition" })
  )
  vim.keymap.set(
    "n",
    "gi",
    '<cmd>lua require"telescope.builtin".lsp_implementations{}<CR>',
    vim.tbl_extend("force", opts, { desc = "LSP go to implementation" })
  )
  vim.keymap.set(
    "n",
    "gr",
    '<cmd>lua require"telescope.builtin".lsp_references{}<CR>',
    vim.tbl_extend("force", opts, { desc = "LSP show references" })
  )

  -- Document symbols
  vim.keymap.set(
    "n",
    "gw",
    '<cmd>lua require"telescope.builtin".lsp_document_symbols{}<CR>',
    vim.tbl_extend("force", opts, { desc = "LSP document symbols" })
  )
  vim.keymap.set(
    "n",
    "gW",
    '<cmd>lua require"telescope.builtin".lsp_workspace_symbols{}<CR>',
    vim.tbl_extend("force", opts, { desc = "LSP Workspace symbols" })
  )

  -- Code actions
  vim.keymap.set(
    "n",
    "<leader>ca",
    '<cmd>lua require"telescope.builtin".lsp_code_actions{}<CR>',
    vim.tbl_extend("force", opts, { desc = "LSP show code actions" })
  )
end

-- Completion (cmp) keymaps setup function
function M.get_cmp_mappings(cmp, has_words_before)
  return cmp.mapping.preset.insert({
    -- Scroll documentation
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),

    -- Complete
    ["<C-space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),

    -- Cancel
    ["<C-y>"] = cmp.config.disable,
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),

    -- Confirm selection
    ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Only confirm explicitly selected items

    -- Navigate items
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),

    -- Tab completion
    ["<Tab>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end),
    ["<S-Tab>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end),
  })
end

return M
