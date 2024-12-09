--[[
  Change runtimepath

  - Add directory for gentoo-syntax (/usr/share/vim/vimfiles)
  - Current runtimepath can be displayed by :set runtimepath?
  - This has to be done first (before loading plugin manager or doing anything else)
  - default: '~/.config/nvim,/etc/xdg/nvim,~/.local/share/nvim/site,/usr/local/share/nvim/site,/usr/share/nvim/site,/etc/eselect/wine/share/nvim/site,/usr/share/gdm/nvim/site,/usr/share/nvim/runtime,/usr/share/nvim/runtime/pack/dist/opt/matchit,/usr/lib/nvim,/usr/share/gdm/nvim/site/after,/etc/eselect/wine/share/nvim/site/after,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,~/.local/share/nvim/site/after,/etc/xdg/nvim/after,~/.config/nvim/after'
  - see :help rtp

--]]
--[[
-- This config is obsolete.
-- With lazy.nvim, the rtp is changed after loading the plugin manager.
-- This reverts the changes done here. To still be able to add the
-- /usr/share/vim/vimfiles dir for gentoo syntax, there are 2 options:
-- 1. deactivate rtp overwrite by lazy (and keep this config here)
-- 2. add the path directly to lazy and remove this config here
-- -> we choose option 2 since most of the directories in this config
--    don't even exist in the filesystem. See lua/core/lazy.lua

vim.opt.runtimepath = '~/.config/nvim,'..                                 -- user config dir

                      '~/.local/share/nvim/site,'..                       -- user site dir
                      '/usr/local/share/nvim/site,'..                     -- local site dir
                      '/usr/share/nvim/site,'..                           -- global site dir

                      '/usr/share/nvim/runtime,'..                        -- global runtime dir
                      '/usr/share/nvim/runtime/pack/dist/opt/matchit,'..  -- global matchit

                      '/usr/share/vim/vimfiles,'..                        -- gentoo-syntax files

                      '/usr/share/nvim/site/after,'..                     -- global after dir
                      '/usr/local/share/nvim/site/after,'..               -- local after dir
                      '~/.local/share/nvim/site/after,'..                 -- user after dir
                      '~/.config/nvim/after'                              -- user config after dir

 ]]
-- Nvim options
require("core.globals")
require("core.keymaps")
require("core.filetype")
--require("core.lsp")  -- override location handler for lsp functions (don't use for now)
require("core.lazy")   -- Must come AFTER setting mapleader and maplocalleader in globals
