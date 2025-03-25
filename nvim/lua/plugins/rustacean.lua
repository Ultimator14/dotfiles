-- Rust support for debugging etc.
-- This plugin populates dap with some configs.
-- Without it, we would have to do all the workspace finding, runner creation etc. by ourselves
return {
  'mrcjkb/rustaceanvim',
  version = '^5',  -- Recommended
  ft = {"rust"}
  -- The config for this plugin is done in lspconfig.lua
}
