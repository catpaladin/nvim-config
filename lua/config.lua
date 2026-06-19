-- ============================================================================
-- Plugin Configuration (defaults)
-- To override, create config.local.lua (gitignored)
-- ============================================================================

local defaults = {
  -- AI Assistance (set to false to disable)
  codeium = false,
  claudecode = false,
  opencode = false,

  -- Language Support (set to false to disable)
  lang = {
    go = true,
    typescript = true,
    astro = false,
    rust = false,
    python = true,
    terraform = true,
  },

  -- Paths (adjust for your system)
  paths = {
    claude_cli = "claude",  -- Assumes claude is in PATH
    python_venv = ".venv/bin/python",
    typescript_sdk = "$HOME/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib",
  },
}

-- Load local overrides if they exist
local config_path = vim.fn.stdpath("config") .. "/lua/config.local.lua"
local ok, local_config = false, nil
if vim.fn.filereadable(config_path) == 1 then
  ok, local_config = pcall(dofile, config_path)
end
if ok and type(local_config) == "table" then
  -- Deep merge local config into defaults
  for key, value in pairs(local_config) do
    if type(value) == "table" and type(defaults[key]) == "table" then
      for k, v in pairs(value) do
        defaults[key][k] = v
      end
    else
      defaults[key] = value
    end
  end
end

return defaults
