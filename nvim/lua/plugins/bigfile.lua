-- (Very) Large files
local nvim_cmp = {
  name = "nvim_cmp",                                                        -- name
  opts = { defer = false },                                                 -- set to true if `disable` should be called on `BufReadPost` and not `BufReadPre`
  disable = function() require('cmp').setup.buffer { enabled = false } end, -- called to disable the feature
}

local lualine = {
  name = "lualine",
  opts = { defer = false },
  disable = function() require('lualine').hide() end,
}

return {
  'LunarVim/bigfile.nvim',
  opts = {
    filesize = 10,         -- size of the file in MiB, the plugin round file sizes to the closest MiB
    pattern = { "*" },     -- autocmd pattern or function see <### Overriding the detection of big files>
    features = {           -- features to disable
      "lsp",
      "treesitter",
      "syntax",
      "vimopts",
      "filetype",
      nvim_cmp,
      --lualine
    }
  }
}
