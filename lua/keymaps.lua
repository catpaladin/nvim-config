local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local keymap = vim.api.nvim_set_keymap

-- Leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- ============================================================================
-- LSP Keymaps (buffer-local, set on LspAttach)
-- ============================================================================
local M = {}

function M.setup_lsp_keymaps(bufnr)
  local bufopts = { buffer = bufnr, noremap = true, silent = true }

  -- Hover and diagnostics
  vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", bufopts, { desc = "LSP hover" }))
  vim.keymap.set("n", "<leader>ds", vim.diagnostic.open_float, vim.tbl_extend("force", bufopts, { desc = "Show diagnostic" }))

  -- Navigation (via Telescope)
  vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", vim.tbl_extend("force", bufopts, { desc = "Go to definition" }))
  vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", vim.tbl_extend("force", bufopts, { desc = "Go to type definition" }))
  vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", vim.tbl_extend("force", bufopts, { desc = "Go to implementation" }))
  vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", vim.tbl_extend("force", bufopts, { desc = "Show references" }))

  -- Symbols
  vim.keymap.set("n", "gw", "<cmd>Telescope lsp_document_symbols<CR>", vim.tbl_extend("force", bufopts, { desc = "Document symbols" }))
  vim.keymap.set("n", "gW", "<cmd>Telescope lsp_workspace_symbols<CR>", vim.tbl_extend("force", bufopts, { desc = "Workspace symbols" }))

  -- Actions
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", bufopts, { desc = "Code actions" }))
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", bufopts, { desc = "Rename symbol" }))

  -- Diagnostic navigation
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", bufopts, { desc = "Previous diagnostic" }))
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", bufopts, { desc = "Next diagnostic" }))
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, vim.tbl_extend("force", bufopts, { desc = "Diagnostics to loclist" }))
end

-- Modes
--   normal_mode        = "n",
--   insert_mode        = "i",
--   visual_mode        = "v",
--   visual_block_mode  = "x",
--   term_mode          = "t",
--   command_mode       = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Naviagate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Close buffers
keymap("n", "<S-q>", ":bd<CR>", opts)

-- Neo-tree
keymap("n", "<C-n>", ":Neotree toggle<CR>", opts)
keymap("n", "<C-g>", ":Neotree float git_status<CR>", opts)

-- Toggleterm
keymap("n", "<C-\\>", ":ToggleTerm<CR>", opts)

-- Format
keymap("n", "<leader>f", ":Format<CR>", opts)
keymap("n", "<leader>fw", ":FormatWrite<CR>", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- markdown preview
keymap("n", "<leader>mp", ":MarkdownPreviewToggle<cr>", opts)

-- Comment toggle (uses native gc in 0.10+)
keymap("n", "//", "gcc", { noremap = false, silent = true })
keymap("v", "//", "gc", { noremap = false, silent = true })

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Command --
-- Menu navigation
keymap("c", "<C-j>", 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true })
keymap("c", "<C-k>", 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true })

return M
