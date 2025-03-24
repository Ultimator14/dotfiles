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
    -- Highlight current indetation scope
    -- do some changes to improve animation speed
    require("mini.indentscope").setup({
      delay = 20,                                -- delay until animation start
      animation = function(s, n) return 10 end,  -- delay between animation steps
    })
  end
}
