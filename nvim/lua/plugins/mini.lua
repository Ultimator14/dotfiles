-- The nvim mini library
return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    -- Enable more keymaps related to va* and vi*
    -- e.g. enable va<space>, v2a" etc.
    require("mini.ai").setup()
    -- Enable management of surroundings chars
    -- like to nvim-surround but with better keymaps
    require("mini.surround").setup()
  end
}
