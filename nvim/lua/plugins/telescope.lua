-- Fuzzy finding
return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  cmd = "Telescope",
  dependencies = {
    'nvim-lua/plenary.nvim',           -- required
    'nvim-treesitter/nvim-treesitter', -- treesitter preview highlighting
    'nvim-tree/nvim-web-devicons'      -- icons
  },
  keys = {
    { '<leader>ff', function() require('telescope.builtin').find_files() end, desc = 'Find files', mode = "n" },
    { '<leader>fg', function() require('telescope.builtin').live_grep() end, desc = 'Find filecontent (ripgrep)', mode = "n" },
    { '<leader>fb', function() require('telescope.builtin').buffers() end, desc = 'Find buffers', mode = "n" },
    { '<leader>fh', function() require('telescope.builtin').help_tags() end, desc = 'Find help', mode = "n" },
    { '<leader>fc', function() require('telescope.builtin').commands() end, desc = 'Find command', mode = "n" }
  },
  opts = {}
}
