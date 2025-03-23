-- Buffer/Mark/Tab/Colorscheme switcher
return {
  'toppair/reach.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = "ReachOpen",
  keys = {
    { '<leader>gb', function() require("reach").buffers() end, desc = "Reach buffer", mode = "n", silent = true },
    { '<leader>gm', function() require("reach").marks() end, desc = "Reach mark", mode = "n", silent = true },
    { '<leader>gt', function() require("reach").tabpages() end, desc = "Reach tab", mode = "n", silent = true },
    { '<leader>gc', function() require("reach").colorschemes() end, desc = "Reach colorscheme", mode = "n", silent = true}
  },
  opts = {}
}
