-- Git
return {
  'lewis6991/gitsigns.nvim',
  config = function()
    -- set colors
    -- see https://github.com/lewis6991/gitsigns.nvim/wiki/FAQ#how-do-i-change-the-color-of-x
    -- see :help gitsigns-highlight-groups
    vim.api.nvim_set_hl(0, 'GitSignsAdd', {fg="#009900"})
    vim.api.nvim_set_hl(0, 'GitSignsChange', {fg="#ffdd00"})
    vim.api.nvim_set_hl(0, 'GitSignsDelete', {fg="#ff2222"})

    vim.api.nvim_set_hl(0, 'GitSignsUntracked', {fg="#009900"})
    vim.api.nvim_set_hl(0, 'GitSignsChangeDelete', {fg="#ffdd00"})
    vim.api.nvim_set_hl(0, 'GitSignsTopdelete', {fg="#ff2222"})

    require('gitsigns').setup{
      signs = {
        add          = { text = '+' },
        change       = { text = '┃' },
        delete       = { text = '▁' },
        topdelete    = { text = '▔' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      }
    }
  end
}
