--[[
--
-- Custom Keybindings
--
-- - All default bindings can be found at https://neovim.io/doc/user/vimindex.html
--
--]]

-- wq
vim.keymap.set('n', '<leader>w', ':w<cr>', { desc = 'Write file', silent = true })
vim.keymap.set('n', '<leader>q', ':q<cr>', { desc = 'Quit file', silent = true })

-- Buffers
vim.keymap.set('n', '<leader>bd', ':bd<cr>', { desc = 'Delete current buffer', silent = true })
vim.keymap.set('n', '<leader>bn', ':bnext<cr>', { desc = 'Show next buffer', silent = true })
vim.keymap.set('n', '<leader>bp', ':bprev<cr>', { desc = 'Show previous buffer', silent = true })

-- Tabs
vim.keymap.set('n', '<leader>t', ':tabnew<cr>', { desc = 'New tab', silent = true })
vim.keymap.set('n', '<Tab>', ':tabn<cr>', { desc = 'Next tab', silent = true })
vim.keymap.set('n', '<S-Tab>', ':tabp<cr>', { desc = 'Previous tab', silent = true })

-- Split navigations
vim.keymap.set('n', '<C-J>', '<C-W><C-J>', { desc = 'Go to window below'})
vim.keymap.set('n', '<C-K>', '<C-W><C-K>', { desc = 'Go to window above'})
vim.keymap.set('n', '<C-L>', '<C-W><C-L>', { desc = 'Go to window right'})
vim.keymap.set('n', '<C-H>', '<C-W><C-H>', { desc = 'Go to window left'})

-- Move Lines
vim.keymap.set('n', '<A-j>', ':m .+1<cr>==', { desc = 'Move line down', silent = true })
vim.keymap.set('n', '<A-k>', ':m .-2<cr>==', { desc = 'Move line up', silent = true })
vim.keymap.set('v', '<A-j>', ':m ">+1<cr>gv=gv', { desc = 'Move line down', silent = true })
vim.keymap.set('v', '<A-k>', ':m "<-2<cr>gv=gv', { desc = 'Move line up', silent = true })
vim.keymap.set('i', '<A-j>', '<Esc>:m .+1<cr>==gi', { desc = 'Move line down', silent = true })
vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<cr>==gi', { desc = 'Move line up', silent = true })

-- Add undo breakpoints at dot, comma and semicolon
-- (pressing u to undo will then only remove text written after the last .,;)
vim.keymap.set('i', ',', ',<c-g>u')
vim.keymap.set('i', '.', '.<c-g>u')
vim.keymap.set('i', ';', ';<c-g>u')

-- Keep visual mode after visual indent
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Clear search
vim.keymap.set('n', '<leader>h', ':nohlsearch<cr>', { desc = 'Clear search', silent = true })

-- Use ctrl + backspace to delete last word
vim.keymap.set('i', '<c-bs>', '<c-w>', { desc = 'Delete last word' })

-- Undo cursor movement is ctrl+o
-- Redo cursor moevement is ctrl+i
-- However ctrl+i == Tab and we override Tab for completion purposes
-- Therefore use another keybinding for 'redo cursor movement'
vim.keymap.set('n', '<C-p>', '<C-i>', { desc = "Go to newer cursor position in jump list", noremap = true, silent = true })
