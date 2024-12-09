--[[
--
-- Global settings
--
--]]

-- If exists, remove leader keymap
-- vim.keymap.del('n', '<SPACE>')

local globals = {
  mapleader = ' ',                  -- Leader keys
  maplocalleader = ',',             -- (default is \), used e.g. for activating tex compilation
  leave_my_textwidth_alone = 1,     -- disable gentoos textwidth behavior (set by /etc/vim/sysinit.vim)
  loaded_netrw = 1,                 -- disable netrw (vims integrated file explorer), replaced by nvim-tree
  loaded_netrwPlugin = 1,
}

for k, v in pairs(globals) do
  vim.g[k] = v
end

local options = {
  tabstop = 4,                      -- don't indent tabs so much (only like 4 spaces)
  shiftwidth = 4,
  number = true,                    -- activate line numbers + relative numbers
  relativenumber = true,
  timeout = true,                   -- Enable command timeout to show which-key
  timeoutlen = 500,
  updatetime = 100,                 -- update ui more often (required for displaying changes faster on the left side e.g. lsp warnings, git symbols)
  termguicolors = true,             -- set termguicolors to enable highlight groups (required for nvim-tree and maybe colorscheme)
  background = "dark",              -- set dark background (in case theme has dark and light mode)
  textwidth = 0,                    -- do not break long lines
  smartcase = true,                 -- override ignorecase if search pattern contains uppercase (behaves like rg)
  smartindent = true,               -- smart autoindenting on new lines
  foldenable = false,               -- disable folding
  smoothscroll = true,              -- Smooth scrolling on very long lines; scroll visible lines (new in nvim 10)
  scrolloff = 2,                    -- always keep n lines above and below cursor when scrolling
  --conceallevel = 2,                 -- hide concealed text, enable replacement of multiple chars, disable, very unhandy for markdown
  --undofile = true,                  -- use a file to save undo history, disable accidental undo of previous changes
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Config for lsp_lines plugin
vim.diagnostic.config({
  virtual_text = false,                         -- Disable virtual_text since it's redundant due to lsp_lines.
  virtual_lines = { only_current_line = true }  -- Only use lsp_lines for the current line
})
