-- This file enables lazy.nvim to discover plugin specs in the lang/ subdirectory.
-- lazy.nvim's import mechanism only recurses into subdirectories that contain
-- an init.lua file. Without this, specs in lang/*.lua would never be loaded.
return {}