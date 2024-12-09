-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load plugin manager and plugins
local opts = {
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
  performance = {
    -- reset_packpath = false,  -- don't reset lua path
    rtp = {
      -- reset = false,         -- deactivate rtp override; not required; add vimfiles path instead; see init.lua
      paths = { "/usr/share/vim/vimfiles" }
    }
  }
}
require('lazy').setup("plugins", opts)