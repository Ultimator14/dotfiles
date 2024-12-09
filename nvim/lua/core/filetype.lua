-- Per File type behaviour

-- shift 2
vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"arduino", "brainfuck", "haskell", "lua"},
    command = "setlocal shiftwidth=2 tabstop=2 expandtab",
})

-- shift 4
vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"c", "css", "html", "htmldjango", "javascript", "python"},
    command = "setlocal shiftwidth=4 tabstop=4 expandtab",
})

-- Disable some format options for ALL filetypes
-- default: something like 'jtcroql'
-- "j" join multiline comments if possible -> ok
-- "t" auto wrap text on insert -> disable
-- "c" auto wrap comments on insert -> ok
-- "r" continue comments on ENTER -> ok
-- "o" continue comments on pressing o -> disable
-- "q" enable comment formatting with gq -> ok
-- "l" don't break long lines -> ok
-- "n" support numbered lists, auto indent accordingly -> enable

--vim.api.nvim_create_autocmd({"FileType"}, {
--    pattern = {"*"},
--    command = "setlocal formatoptions+=j formatoptions-=t formatoptions+=c formatoptions+=r formatoptions-=o formatoptions+=q formatoptions+=l formatoptions+=n",
--})
