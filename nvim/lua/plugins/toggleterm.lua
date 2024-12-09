-- Toggleterm
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    -- Can't lazyload this.
    -- F8 in zsh enters zsh normal mode. The nvim keybinding must take precedence over this behavior.
    -- This is not the case on lazy loading. Therefore specify keymaps in config instead of keys.
    require('toggleterm').setup()

    -- F8 to toggle terminal
    vim.keymap.set('n', '<F8>', ':ToggleTerm<CR>', { desc = "Toggle Terminal", silent = true })
    vim.keymap.set('t', '<F8>', '<C-\\><C-n>:ToggleTerm<CR>', { desc = "Toggle Terminal", silent = true })

    -- Esc to leave terminal mode
    vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = "Leave Terminal", silent = true })
  end
}
