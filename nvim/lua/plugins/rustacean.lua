-- Rust support for debugging etc.
-- This plugin populates dap with some configs.
-- Without it, we would have to do all the workspace finding, runner creation etc. by ourselves
return {
  'mrcjkb/rustaceanvim',
  version = '^7',  -- Recommended
  ft = {"rust"},
  dependencies = { 'mfussenegger/nvim-dap' }
  -- The config for this plugin is done in lspconfig.lua
}
