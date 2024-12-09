-- Diagnostics window at bottom of screen
return {
  'folke/trouble.nvim',
  cmd = "Trouble",
  keys = {
    { '<leader>d', ':Trouble diagnostics toggle<cr>',  desc = 'Toggle Trouble List', mode = "n", silent = true },
    { '<leader>z', ':Trouble close<cr>',  desc = 'Close Trouble List', mode = "n", silent = true },
    { 'gr', ':Trouble lsp_references toggle<cr>',  desc = 'Show references', mode = "n", silent = true, buffer = bufnr },
    { 'gd', ':Trouble lsp_definitions toggle<cr>',  desc = 'Go to definition', mode = "n", silent = true, buffer = bufnr },
    { 'gt', ':Trouble lsp_type_definitions toggle<cr>',  desc = 'Go to type definition', mode = "n", silent = true, buffer = bufnr }
  },
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    -- auto jump if only one result for these modes
    auto_jump = {
      "lsp_definitions",
      "lsp_type_definitions",
      "lsp_references"
    }
  }
}
