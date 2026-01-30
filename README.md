# neovim config

Developer settings for my development and DevOps tasks. Maybe it will work for you.

## Requirements

- Neovim >= 0.11+
- A [Nerd Font](https://www.nerdfonts.com/) for icons

## Configuration

Default settings are in `lua/config.lua`. To customize without affecting git, create
`lua/config.local.lua` (gitignored):

```lua
-- lua/config.local.lua
return {
  -- Only include settings you want to override
  codeium = false,
  claudecode = true,
  opencode = true,

  cursortab = {
    enabled = true,
    provider = "sweep",
    provider_url = "http://localhost:1234",
    provider_model = "sweep-next-edit-1.5b",
    provider_temperature = 0.0,
    provider_max_tokens = 512,
    provider_top_k = 50,
  },

  lang = {
    astro = true,
    rust = true,
  },

  paths = {
    claude_cli = "~/.local/bin/claude",
  },
}
```

Settings are deep-merged, so you only need to specify overrides. After changing, restart
Neovim and run `:Lazy sync`.

## Plugin Structure

```
lua/plugins/
├── coding.lua      # Completion (blink.cmp), AI (codeium, claudecode, opencode)
├── editor.lua      # UI: bufferline, snacks (terminal, explorer, lazygit)
├── formatting.lua  # conform.nvim
├── lsp.lua         # LSP config, mason
├── telescope.lua   # Fuzzy finder
├── themes.lua      # Colorscheme, statusline
├── treesitter.lua  # Syntax highlighting
└── lang/           # Language-specific (toggleable)
   ├── go.lua
   ├── typescript.lua
   ├── astro.lua
   └── rust.lua
```

## Keymaps

Leader key: `<Space>`

### General

| Key               | Mode | Description                    |
| ----------------- | ---- | ------------------------------ |
| `<C-h/j/k/l>`     | n    | Navigate windows               |
| `<S-h>` / `<S-l>` | n    | Previous/next buffer           |
| `<S-q>`           | n    | Close buffer                   |
| `<C-Up/Down>`     | n    | Resize window vertically       |
| `<C-Left/Right>`  | n    | Resize window horizontally     |
| `<leader>h`       | n    | Clear search highlights        |
| `jk`              | i    | Exit insert mode               |
| `<` / `>`         | v    | Indent and stay in visual mode |
| `J` / `K`         | x    | Move selected lines down/up    |
| `//`              | n, v | Toggle comment                 |

### File Explorer (Snacks Explorer) & Git (LazyGit)

| Key     | Mode | Description            |
| ------- | ---- | ---------------------- |
| `<C-n>` | n    | Toggle snacks explorer |
| `<C-g>` | n    | Open LazyGit           |

### Telescope

| Key          | Mode | Description                 |
| ------------ | ---- | --------------------------- |
| `<leader>p`  | n    | Find files                  |
| `<leader>fs` | n    | Live grep (search in files) |
| `<leader>fb` | n    | Find buffers                |
| `<leader>fh` | n    | Search help tags            |
| `<leader>fw` | n    | Search word under cursor    |
| `<leader>fd` | n    | Search in nvim config       |

### LSP (buffer-local when attached)

| Key          | Mode | Description                  |
| ------------ | ---- | ---------------------------- |
| `K`          | n    | Hover documentation          |
| `gd`         | n    | Go to definition             |
| `gt`         | n    | Go to type definition        |
| `gi`         | n    | Go to implementation         |
| `gr`         | n    | Show references              |
| `gw`         | n    | Document symbols             |
| `gW`         | n    | Workspace symbols            |
| `<leader>ca` | n, v | Code actions                 |
| `<leader>rn` | n    | Rename symbol                |
| `<leader>ds` | n    | Show diagnostic float        |
| `[d` / `]d`  | n    | Previous/next diagnostic     |
| `<leader>q`  | n    | Diagnostics to location list |

### Completion (blink.cmp)

| Key                 | Mode | Description                    |
| ------------------- | ---- | ------------------------------ |
| `<C-Space>`         | i    | Toggle completion/docs         |
| `<Tab>` / `<S-Tab>` | i    | Next/prev item or snippet jump |
| `<C-n>` / `<C-p>`   | i    | Next/prev item                 |
| `<CR>`              | i    | Accept completion              |
| `<C-e>`             | i    | Cancel completion              |
| `<C-b>` / `<C-f>`   | i    | Scroll documentation           |

### Terminal (snacks.terminal)

| Key            | Mode | Description                       |
| -------------- | ---- | --------------------------------- |
| `<C-\>`        | n, t | Toggle terminal                   |
| `<leader>t1-9` | n, t | Toggle bottom terminal 1-9        |
| `<leader>v1-9` | n, t | Toggle right terminal 1-9         |
| `<leader>f1-9` | n, t | Toggle floating terminal 1-9      |
| `<C-h/j/k/l>`  | t    | Navigate from terminal to windows |

### TypeScript (when enabled)

| Key          | Mode | Description             |
| ------------ | ---- | ----------------------- |
| `<leader>to` | n    | Organize imports        |
| `<leader>ti` | n    | Add missing imports     |
| `<leader>tF` | n    | Fix all                 |
| `<leader>tu` | n    | Remove unused           |
| `<leader>tR` | n    | Rename file             |
| `<leader>tg` | n    | Go to source definition |

### Go (when enabled)

| Key           | Mode | Description        |
| ------------- | ---- | ------------------ |
| `<leader>gt`  | n    | Run tests          |
| `<leader>gtf` | n    | Run test function  |
| `<leader>gc`  | n    | Show coverage      |
| `<leader>gi`  | n    | Import package     |
| `<leader>gfs` | n    | Fill struct        |
| `<leader>gif` | n    | Add if err         |
| `<leader>gat` | n    | Add struct tags    |
| `<leader>grm` | n    | Remove struct tags |

### Formatting

| Key          | Mode | Description      |
| ------------ | ---- | ---------------- |
| `<leader>f`  | n    | Format           |
| `<leader>fw` | n    | Format and write |

### Claude Code (when enabled)

| Key          | Mode | Description              |
| ------------ | ---- | ------------------------ |
| `<leader>ac` | n    | Toggle Claude            |
| `<leader>af` | n    | Focus Claude             |
| `<leader>ar` | n    | Resume Claude            |
| `<leader>aC` | n    | Continue Claude          |
| `<leader>am` | n    | Select model             |
| `<leader>ab` | n    | Add current buffer       |
| `<leader>as` | v    | Send selection to Claude |
| `<leader>aa` | n    | Accept diff              |
| `<leader>ad` | n    | Deny diff                |

### OpenCode (when enabled)

| Key          | Mode | Description                          |
| ------------ | ---- | ------------------------------------ |
| `<leader>oo` | n, t | Toggle OpenCode                      |
| `<leader>oa` | n, x | Ask OpenCode (with selection/cursor) |
| `<leader>os` | n, x | Select action (built-in prompts)     |
| `<leader>op` | n, x | Add selection to OpenCode            |
| `<leader>ob` | n    | Add current buffer                   |
| `<leader>ov` | n    | Add visible text                     |
| `<leader>od` | n    | Add diagnostics                      |
| `<leader>og` | n    | Add git diff                         |
| `<leader>oi` | n    | Interrupt session                    |
| `<leader>on` | n    | New session                          |

**Context Placeholders**: Use `@this`, `@buffer`, `@buffers`, `@visible`,
`@diagnostics`, `@quickfix`, `@diff` in prompts.

**Built-in Prompts** (via `<leader>os`): diagnostics, diff, document, explain, fix,
implement, optimize, review, test.

### Other

| Key          | Mode | Description            |
| ------------ | ---- | ---------------------- |
| `<leader>mp` | n    | Toggle markdown render |
| `<leader>n`  | n    | Notification history   |
| `<leader>un` | n    | Dismiss notifications  |
